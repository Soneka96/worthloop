package io.github.soneka96.worthloop

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL =
            "io.github.soneka96.worthloop/background_capabilities"
        private const val PRICE_ALERT_CHANNEL = "price_alerts"
        private const val PRICE_ALERT_PERMISSION_REQUEST = 4001
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "read" -> result.success(readCapabilities())
                    "openBatterySettings" -> result.success(openBatterySettings())
                    else -> result.notImplemented()
                }
            }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "io.github.soneka96.worthloop/background_refresh",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> result.success(startBackgroundRefresh())
                "stop" -> result.success(stopBackgroundRefresh())
                "isRunning" -> result.success(BackgroundRefreshService.isRunning)
                else -> result.notImplemented()
                }
            }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "io.github.soneka96.worthloop/price_alert_notifications",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "areNotificationsEnabled" ->
                    result.success(areNotificationsEnabled())
                "requestPermission" -> result.success(requestNotificationPermission())
                "showPriceDrop" -> {
                    val productId = call.argument<String>("productId")
                    val title = call.argument<String>("title")
                    val body = call.argument<String>("body")
                    if (productId == null || title == null || body == null) {
                        result.success(false)
                    } else {
                        result.success(showPriceDrop(productId, title, body))
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun readCapabilities(): Map<String, Any?> {
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        val standbyBucket = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val usageStatsManager =
                getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
            usageStatsManager.appStandbyBucket
        } else {
            null
        }

        return mapOf(
            "isSupported" to true,
            "manufacturer" to Build.MANUFACTURER,
            "model" to Build.MODEL,
            "androidSdk" to Build.VERSION.SDK_INT,
            "isIgnoringBatteryOptimizations" to
                powerManager.isIgnoringBatteryOptimizations(packageName),
            "standbyBucket" to standbyBucket,
        )
    }

    private fun openBatterySettings(): Boolean {
        return try {
            startActivity(Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS))
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun startBackgroundRefresh(): Boolean {
        return try {
            val intent = Intent(this, BackgroundRefreshService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(intent)
            } else {
                startService(intent)
            }
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun stopBackgroundRefresh(): Boolean {
        return stopService(Intent(this, BackgroundRefreshService::class.java))
    }

    private fun areNotificationsEnabled(): Boolean =
        NotificationManagerCompat.from(this).areNotificationsEnabled()

    private fun requestNotificationPermission(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU ||
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS,
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            return true
        }
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.POST_NOTIFICATIONS),
            PRICE_ALERT_PERMISSION_REQUEST,
        )
        return true
    }

    private fun showPriceDrop(productId: String, title: String, body: String): Boolean {
        if (!areNotificationsEnabled()) {
            return false
        }
        createPriceAlertChannel()
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("price_alert_product_id", productId)
        }
        val pendingIntent = android.app.PendingIntent.getActivity(
            this,
            productId.hashCode(),
            intent,
            android.app.PendingIntent.FLAG_UPDATE_CURRENT or
                android.app.PendingIntent.FLAG_IMMUTABLE,
        )
        val notification = NotificationCompat.Builder(this, PRICE_ALERT_CHANNEL)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setCategory(NotificationCompat.CATEGORY_EVENT)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()
        NotificationManagerCompat.from(this).notify(productId.hashCode(), notification)
        return true
    }

    private fun createPriceAlertChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                PRICE_ALERT_CHANNEL,
                "Price alerts",
                NotificationManager.IMPORTANCE_DEFAULT,
            )
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }
    }
}
