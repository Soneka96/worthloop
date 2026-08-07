package io.github.soneka96.worthloop

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.FlutterInjector
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.concurrent.atomic.AtomicBoolean

class BackgroundRefreshService : Service() {
    companion object {
        const val CHANNEL_ID = "background_refresh"
        const val NOTIFICATION_ID = 1001
        const val ACTION_REQUEST_REFRESH =
            "io.github.soneka96.worthloop.action.REQUEST_REFRESH"
        const val ENGINE_CHANNEL =
            "io.github.soneka96.worthloop/background_refresh_engine"

        private val pendingRefreshRequest = AtomicBoolean(false)

        var isRunning: Boolean = false

        fun consumePendingRefreshRequest(): Boolean {
            return pendingRefreshRequest.getAndSet(false)
        }
    }

    private var flutterEngine: FlutterEngine? = null
    private var engineChannel: MethodChannel? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, createNotification())
        isRunning = true
        startFlutterEngine()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_REQUEST_REFRESH) {
            pendingRefreshRequest.set(true)
            notifyFlutterEngine()
        }
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        isRunning = false
        pendingRefreshRequest.set(false)
        engineChannel = null
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
            .build()
    }

    private fun startFlutterEngine() {
        val engine = FlutterEngine(this)
        GeneratedPluginRegistrant.registerWith(engine)
        val channel = MethodChannel(engine.dartExecutor.binaryMessenger, ENGINE_CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "consumePendingRefreshRequest" ->
                    result.success(consumePendingRefreshRequest())
                "stopService" -> {
                    stopSelf()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
        engineChannel = channel
        flutterEngine = engine
        val loader: FlutterLoader = FlutterInjector.instance().flutterLoader()
        val entrypoint = DartExecutor.DartEntrypoint(
            loader.findAppBundlePath(),
            "backgroundRefreshEntrypoint",
        )
        engine.dartExecutor.executeDartEntrypoint(entrypoint)
    }

    private fun notifyFlutterEngine() {
        engineChannel?.invokeMethod("refreshNow", null)
    }
}
