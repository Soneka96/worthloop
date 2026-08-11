package io.github.soneka96.worthloop

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.FlutterInjector
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.view.FlutterCallbackInformation
import java.util.Collections

class BackgroundRefreshService : Service() {
    companion object {
        const val CHANNEL_ID = "background_refresh"
        const val NOTIFICATION_ID = 1001
        const val RESULT_NOTIFICATION_ID = 1002
        const val RESULT_CHANNEL_ID = "background_refresh_results"
        const val ACTION_REQUEST_REFRESH =
            "io.github.soneka96.worthloop.action.REQUEST_REFRESH"
        const val EXTRA_SOURCE_IDS = "source_ids"
        const val EXTRA_BYPASS_COOLDOWN = "bypass_cooldown"
        const val ENGINE_CHANNEL =
            "io.github.soneka96.worthloop/background_refresh_engine"
        const val PRICE_ALERT_CHANNEL_NAME =
            "io.github.soneka96.worthloop/price_alert_notifications"
        const val PREFS_NAME = "worth_loop_background_refresh"
        const val CALLBACK_HANDLE_KEY = "callback_handle"

        private val pendingSourceIds = Collections.synchronizedList(mutableListOf<String>())

        var isRunning: Boolean = false

        fun consumePendingSourceIds(): List<String> {
            synchronized(pendingSourceIds) {
                val drained = pendingSourceIds.toList()
                pendingSourceIds.clear()
                return drained
            }
        }
    }

    private var flutterEngine: FlutterEngine? = null
    private var engineChannel: MethodChannel? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, createNotification())
        isRunning = true
    }

    private var engineStarted = false

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val sourceIds = if (intent?.action == ACTION_REQUEST_REFRESH) {
            intent.getStringArrayListExtra(EXTRA_SOURCE_IDS) ?: arrayListOf()
        } else {
            null
        }
        if (sourceIds != null) {
            synchronized(pendingSourceIds) {
                pendingSourceIds.addAll(sourceIds)
            }
            updateForegroundNotification("Refreshing prices…")
        }
        if (!engineStarted) {
            engineStarted = startFlutterEngine()
        } else if (sourceIds != null && sourceIds.isEmpty()) {
            engineChannel?.invokeMethod("rescheduleRefresh", null)
        } else if (sourceIds != null) {
            // ponytail: a bypass-cooldown request made while the engine is
            // cold-starting (the branch above) loses that hint and queues
            // normally instead — rare enough that thread-through isn't worth
            // the extra native plumbing. Only the already-running path here
            // honors it.
            val bypassCooldown = intent?.getBooleanExtra(EXTRA_BYPASS_COOLDOWN, false) ?: false
            notifyFlutterEngine(sourceIds, bypassCooldown)
        }
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        isRunning = false
        synchronized(pendingSourceIds) {
            pendingSourceIds.clear()
        }
        engineChannel = null
        engineStarted = false
        flutterEngine?.destroy()
        flutterEngine = null
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Background price refresh",
                NotificationManager.IMPORTANCE_LOW,
            )
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
            val resultChannel = NotificationChannel(
                RESULT_CHANNEL_ID,
                "Background refresh results",
                NotificationManager.IMPORTANCE_DEFAULT,
            )
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(resultChannel)
        }
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("WorthLoop")
            .setContentText("Background price refresh is enabled")
            .setOngoing(true)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setContentIntent(contentPendingIntent())
            .build()
    }

    private fun contentPendingIntent(): PendingIntent {
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        return PendingIntent.getActivity(
            this,
            NOTIFICATION_ID,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun updateForegroundNotification(
        message: String,
        progress: Pair<Int, Int>? = null,
    ) {
        NotificationManagerCompat.from(this).notify(
            NOTIFICATION_ID,
            createNotification(message, progress),
        )
    }

    private fun createNotification(
        message: String,
        progress: Pair<Int, Int>? = null,
    ): Notification {
        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("WorthLoop")
            .setContentText(message)
            .setOngoing(true)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setContentIntent(contentPendingIntent())
        if (progress != null) {
            val (completed, total) = progress
            builder.setProgress(total, completed, false)
        }
        return builder.build()
    }

    private fun showRefreshResult(title: String, message: String) {
        NotificationManagerCompat.from(this).notify(
            RESULT_NOTIFICATION_ID,
            NotificationCompat.Builder(this, RESULT_CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(title)
                .setContentText(message)
                .setContentIntent(contentPendingIntent())
                .setAutoCancel(true)
                .setCategory(NotificationCompat.CATEGORY_EVENT)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .build(),
        )
    }

    private fun startFlutterEngine(): Boolean {
        val handle = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getLong(CALLBACK_HANDLE_KEY, 0L)
        val callbackInfo = if (handle != 0L) {
            FlutterCallbackInformation.lookupCallbackInformation(handle)
        } else {
            null
        }
        if (callbackInfo == null) {
            stopSelf()
            return false
        }
        val engine = FlutterEngine(this)
        GeneratedPluginRegistrant.registerWith(engine)
        val channel = MethodChannel(engine.dartExecutor.binaryMessenger, ENGINE_CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "consumePendingSourceIds" ->
                    result.success(consumePendingSourceIds())
                "refreshNow" -> {
                    val sourceIds = consumePendingSourceIds()
                    if (sourceIds.isNotEmpty()) {
                        val bypassCooldown = (call.arguments as? Map<*, *>)?.get("bypassCooldown") as? Boolean ?: false
                        notifyFlutterEngine(sourceIds, bypassCooldown)
                    }
                    result.success(true)
                }
                "stopService" -> {
                    stopSelf()
                    result.success(true)
                }
                "refreshStarted" -> {
                    updateForegroundNotification("Refreshing prices…")
                    result.success(true)
                }
                "refreshCompleted" -> {
                    updateForegroundNotification("Last refresh completed")
                    if ((call.arguments as? Map<*, *>)?.get("showResult") == true) {
                        showRefreshResult("Refresh complete", "Product prices were updated")
                    }
                    result.success(true)
                }
                "refreshFailed" -> {
                    updateForegroundNotification("Last refresh failed")
                    if ((call.arguments as? Map<*, *>)?.get("showResult") == true) {
                        showRefreshResult(
                            "Refresh failed",
                            "Some product prices could not be updated",
                        )
                    }
                    result.success(true)
                }
                "updateProgress" -> {
                    val arguments = call.arguments as? Map<*, *>
                    val completed = (arguments?.get("completed") as? Int) ?: 0
                    val total = (arguments?.get("total") as? Int) ?: 0
                    updateForegroundNotification(
                        "Refreshing prices… ($completed/$total)",
                        completed to total,
                    )
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
        engineChannel = channel

        MethodChannel(engine.dartExecutor.binaryMessenger, PRICE_ALERT_CHANNEL_NAME)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "areNotificationsEnabled" ->
                        result.success(PriceAlertNotifier.areNotificationsEnabled(this))
                    "showPriceDrop" -> {
                        val productId = call.argument<String>("productId")
                        val title = call.argument<String>("title")
                        val body = call.argument<String>("body")
                        if (productId == null || title == null || body == null) {
                            result.success(false)
                        } else {
                            result.success(
                                PriceAlertNotifier.showPriceDrop(this, productId, title, body),
                            )
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        flutterEngine = engine
        val loader: FlutterLoader = FlutterInjector.instance().flutterLoader()
        engine.dartExecutor.executeDartCallback(
            DartExecutor.DartCallback(assets, loader.findAppBundlePath(), callbackInfo),
        )
        return true
    }

    private fun notifyFlutterEngine(sourceIds: List<String>, bypassCooldown: Boolean) {
        engineChannel?.invokeMethod(
            "enqueueSources",
            mapOf("sourceIds" to sourceIds, "bypassCooldown" to bypassCooldown),
        )
    }
}
