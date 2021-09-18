package `in`.techbyvishesh.app_utils


import Errors
import Keys
import android.content.Context
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.net.Uri
import android.os.Build
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*


fun Context.launchApp(args: Map<String, Any>, result: Result) {
    Build.DISPLAY
    val packageName = args[Keys.APP_IDENTIFIER] as String?
    val storeUrl = args[Keys.STORE_URL] as String?
    val isLaunchStore = args[Keys.LAUNCH_STORE] as Boolean?
    val data = args[Keys.DATA] as HashMap<String, *>? ?: mutableMapOf<String, Any>()
    val launchIntent = packageManager?.getLaunchIntentForPackage(packageName.toString())
    if (launchIntent != null) {
        val bundle = Bundle()
        data.forEach { entry -> insertEntryInBundle(entry, bundle) }
        launchIntent.putExtras(bundle)
        startActivity(launchIntent)
        result.success(true)
    } else {
        if (isLaunchStore == true) {
            val openURL = Intent(Intent.ACTION_VIEW)
            openURL.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            openURL.data = Uri.parse(storeUrl)
            startActivity(openURL)
            result.success(true)
        } else {
            result.error(Errors.ERROR_NOT_FOUND, "Application isn't installed on your device", null)
        }
    }
}


fun Context.getInstalledApplications(result: Result) {
    try {
        val packages = packageManager.getInstalledPackages(PackageManager.GET_META_DATA)
        val apps = packages.map { bundleInfo ->
            HashMap<String, Any>().apply {
                put(Keys.APP_IDENTIFIER, bundleInfo.packageName)
                put(Keys.APP_NAME, bundleInfo.applicationInfo.loadLabel(packageManager).toString())
                put(Keys.VERSION, bundleInfo.versionName)
                put(
                    Keys.BUILD_NO,
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) bundleInfo.longVersionCode
                    else bundleInfo.versionCode
                )
            }
        }.toList()
        result.success(apps)
    } catch (e: Exception) {
        result.error(Errors.DEFAULT_ERROR, "No able to query packages", null)
    }
}


fun Context.checkCanLaunchApp(args: Map<String, Any>, result: Result) {
    try {
        val packageName = args[Keys.APP_IDENTIFIER].toString().trim()
        val packageManager: PackageManager = packageManager
        val mainIntent = Intent(Intent.ACTION_MAIN, null)
        mainIntent.addCategory(Intent.CATEGORY_LAUNCHER)
        val apps = packageManager.queryIntentActivities(
            mainIntent, 0
        )
        Collections.sort(apps, ResolveInfo.DisplayNameComparator(packageManager))
        for (resolveInfo in apps) {
            if (resolveInfo.activityInfo.packageName == packageName) {
                result.success(true)
                return
            }
        }
        result.success(false)
    } catch (e: Exception) {
        result.error(
            Errors.ERROR_NOT_FOUND,
            "Something went wrong while getting packages details",
            null
        )
    }
}

fun Context.getDeviceInfo(result: Result) {
    result.success(mutableMapOf<String, Any>().apply {
        put(Keys.DEVICE_NAME, Build.MODEL)
        put(Keys.DEVICE_BRAND, Build.BRAND)
        put(Keys.DEVICE_ID, Build.ID)
        put(Keys.OS_VERSION, Build.VERSION.SDK_INT.toString())
    })
}

fun Context.getAppInfo(result: Result) {
    val bundleInfo: PackageInfo = packageManager.getPackageInfo(applicationContext.packageName, 0)
    try {
        result.success(mutableMapOf<String, Any>().apply {
            put(Keys.APP_IDENTIFIER, bundleInfo.packageName)
            put(Keys.APP_NAME, bundleInfo.applicationInfo.loadLabel(packageManager).toString())
            put(Keys.VERSION, bundleInfo.versionName)
            put(
                Keys.BUILD_NO,
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) bundleInfo.longVersionCode
                else bundleInfo.versionCode
            )
        })
    } catch (e: Exception) {
        result.error(Errors.ERROR_NOT_FOUND, "unable to fetch app details", null)
    }
}

fun Context.readLaunchedData(result: Result, intent: Intent) {
    try {
        val bundle = intent.extras ?: Bundle()
        val map = mutableMapOf<String, Any?>()
        val values = bundle.keySet().mapNotNull {
            val value = bundle.get(it)
            if (isSupportedValue(value)) it to value
            else null
        }
        map.putAll(values)
        result.success(map)
    } catch (e: Exception) {
        result.error(Errors.DEFAULT_ERROR, "Unable to read luanch data from app", null)
    }
}

private fun isSupportedValue(value: Any?): Boolean {
    return value is Int ||
            value is Double ||
            value is Float ||
            value is Long ||
            value is String ||
            value is Boolean
}

private fun insertEntryInBundle(entry: Map.Entry<String, out Any>, bundle: Bundle) {
    when (val value = entry.value) {
        is Int -> {
            bundle.putInt(entry.key, value)
        }
        is Double -> {
            bundle.putDouble(entry.key, value)
        }
        is Float -> {
            bundle.putFloat(entry.key, value)
        }
        is Long -> {
            bundle.putLong(entry.key, value)
        }
        is Boolean -> {
            bundle.putBoolean(entry.key, value)
        }
        is String -> {
            bundle.putString(entry.key, value)
        }
    }
}

fun Context.openDeviceSettings(args: Map<String, Any>,result: Result) {
    try {
        val type= args[Keys.TYPE].toString()
        val intent = Intent(getUriFromType(type))
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
        result.success(null)
    } catch (e: Exception) {
        result.error(Errors.DEFAULT_ERROR, "Unable to open settings", null)
    }
}

fun getUriFromType(type: String?): String {
    return when (type?.replace("AndroidSettingsType.","")) {
        "APPLICATION" -> "android.settings.APPLICATION_SETTINGS"
        "WIFI" -> "android.settings.WIFI_SETTINGS"
        "DATA_ROAM" -> "android.settings.DATA_ROAMING_SETTINGS"
        "LOCATION" -> "android.settings.LOCATION_SOURCE_SETTINGS"
        "BLUETOOTH" -> "android.settings.BLUETOOTH_SETTINGS"
        "NOTIFICATION" -> "android.settings.NOTIFICATION_SETTINGS"
        "SECURITY" -> "android.settings.SECURITY_SETTINGS"
        "SOUND" -> "android.settings.SOUND_SETTINGS"
        "MAIN" -> "android.settings.SETTINGS"
        "DATE" -> "android.settings.DATE_SETTINGS"
        "ACCESSIBILITY" -> "android.settings.ACCESSIBILITY_SETTINGS"
        "ACCOUNT" -> "android.settings.ADD_ACCOUNT_SETTINGS"
        "AIRPLANE_MODE" -> "android.settings.AIRPLANE_MODE_SETTINGS"
        "APN_SETTINGS" -> "android.settings.APN_SETTINGS"
        "APPLICATION_DETAILS" -> "android.settings.APPLICATION_DETAILS_SETTINGS"
        "DEVELOPMENT" -> "application_development"
        "NOTIFICATION_BUBBLE" -> "android.settings.APP_NOTIFICATION_BUBBLE_SETTINGS"
        "APP_NOTIFICATION" -> "android.settings.APP_NOTIFICATION_SETTINGS"
        "SEARCH" -> "android.search.action.SEARCH_SETTINGS"
        "BATTERY_SAVER" -> "android.settings.BATTERY_SAVER_SETTINGS"
        "BIOMETRIC" -> "android.settings.BIOMETRIC_ENROLL"
        "CAPTIONING" -> "android.settings.CAPTIONING_SETTINGS"
        "CAST" -> "android.settings.CAST_SETTINGS"
        else -> "android.settings.APPLICATION_SETTINGS"
    }
}
