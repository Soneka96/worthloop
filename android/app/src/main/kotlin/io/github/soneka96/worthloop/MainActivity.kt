package io.github.soneka96.worthloop

import android.Manifest
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingPriceAlertProductId: String? = null
    private var priceAlertChannel: MethodChannel? = null
    private var pendingNotificationPermissionResult: MethodChannel.Result? = null

    companion object {
        private const val CHANNEL =
            "io.github.soneka96.worthloop/background_capabilities"
        private const val PRICE_ALERT_PERMISSION_REQUEST = 4001
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        pendingPriceAlertProductId = intent?.getStringExtra("price_alert_product_id")
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val productId = intent.getStringExtra("price_alert_product_id")
        if (productId != null) {
            pendingPriceAlertProductId = productId
            priceAlertChannel?.invokeMethod("priceAlertTapped", productId)
        }
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
                "requestRefresh" -> result.success(requestBackgroundRefresh())
                "isRunning" -> result.success(BackgroundRefreshService.isRunning)
                "enqueueSources" -> {
                    val arguments = call.arguments as? Map<*, *>
                    val sourceIds = (arguments?.get("sourceIds") as? List<*>)
                        ?.filterIsInstance<String>()
                    val bypassCooldown = arguments?.get("bypassCooldown") as? Boolean ?: false
                    result.success(
                        if (sourceIds != null) {
                            enqueueSources(sourceIds, bypassCooldown)
                        } else {
                            false
                        },
                    )
                }
                "registerCallbackHandle" -> {
                    val handle = (call.arguments as? Number)?.toLong()
                    result.success(
                        if (handle != null) registerBackgroundCallbackHandle(handle) else false,
                    )
                }
                else -> result.notImplemented()
                }
            }

        val configuredPriceAlertChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "io.github.soneka96.worthloop/price_alert_notifications",
        )
        priceAlertChannel = configuredPriceAlertChannel
        configuredPriceAlertChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialPriceAlertProductId" -> {
                    result.success(pendingPriceAlertProductId)
                    pendingPriceAlertProductId = null
                }
                "areNotificationsEnabled" ->
                    result.success(PriceAlertNotifier.areNotificationsEnabled(this))
                "requestPermission" -> requestNotificationPermission(result)
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

    private fun requestBackgroundRefresh(): Boolean {
        return try {
            val intent = Intent(this, BackgroundRefreshService::class.java).apply {
                action = BackgroundRefreshService.ACTION_REQUEST_REFRESH
            }
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

    private fun enqueueSources(sourceIds: List<String>, bypassCooldown: Boolean): Boolean {
        return try {
            val intent = Intent(this, BackgroundRefreshService::class.java).apply {
                action = BackgroundRefreshService.ACTION_REQUEST_REFRESH
                putStringArrayListExtra(
                    BackgroundRefreshService.EXTRA_SOURCE_IDS,
                    ArrayList(sourceIds),
                )
                putExtra(BackgroundRefreshService.EXTRA_BYPASS_COOLDOWN, bypassCooldown)
            }
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

    private fun registerBackgroundCallbackHandle(handle: Long): Boolean {
        return try {
            getSharedPreferences(BackgroundRefreshService.PREFS_NAME, Context.MODE_PRIVATE)
                .edit()
                .putLong(BackgroundRefreshService.CALLBACK_HANDLE_KEY, handle)
                .apply()
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun requestNotificationPermission(result: MethodChannel.Result) {
        if (PriceAlertNotifier.areNotificationsEnabled(this)) {
            result.success(true)
            return
        }
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU ||
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS,
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            result.success(false)
            return
        }
        pendingNotificationPermissionResult = result
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.POST_NOTIFICATIONS),
            PRICE_ALERT_PERMISSION_REQUEST,
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != PRICE_ALERT_PERMISSION_REQUEST) return
        val granted = grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
        pendingNotificationPermissionResult?.success(granted)
        pendingNotificationPermissionResult = null
    }
}
