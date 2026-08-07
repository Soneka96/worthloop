package io.github.soneka96.worthloop

import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL =
            "io.github.soneka96.worthloop/background_capabilities"
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
}
