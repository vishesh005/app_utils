package `in`.techbyvishesh.app_utils


import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.net.Uri
import android.os.Build
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*
import kotlin.collections.HashMap


fun Context.launchApp(args: Map<String, Any>, result: Result){
    Build.DISPLAY
    val packageName = args[Keys.APP_IDENTIFIER] as String?
    val storeUrl = args[Keys.STORE_URL] as String?
    val isLaunchStore = args[Keys.LAUNCH_STORE] as Boolean?
    val data = args[Keys.DATA] as HashMap<String, *>?
    val launchIntent = packageManager?.getLaunchIntentForPackage(packageName.toString())
    if(launchIntent != null){
         val bundle = Bundle()
         bundle.putSerializable("bundle",data)
        launchIntent.putExtras(bundle)
        startActivity(launchIntent)
        result.success(true)
    }
    else {
        if(isLaunchStore == true){
            val openURL = Intent(Intent.ACTION_VIEW)
            openURL.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            openURL.data = Uri.parse(storeUrl)
            startActivity(openURL)
            result.success(true)
        }
        else {
            result.error(Errors.ERROR_NOT_FOUND,"Application isn't installed on your device",null)
        }
    }
}


fun Context.getInstalledApplications(result: Result){
    try {
        val packages = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
        val apps = packages.map { HashMap<String,Any>().apply {
            put(Keys.APP_IDENTIFIER, it.packageName)
            put(Keys.TARGET_VERSION, it.targetSdkVersion)
            if(Build.VERSION.SDK_INT > Build.VERSION_CODES.O) {
                put(Keys.APP_CATEGORY, it.category)
            }
        } }.toList()
        result.success(apps)
    } catch (e: Exception){
        result.error(Errors.DEFAULT_ERROR,"No able to query packages",null)
    }
}


fun Context.checkCanLaunchApp(args: Map<String, Any>, result: Result){
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
           if(resolveInfo.activityInfo.packageName ==  packageName){
              result.success(true)
              return
           }
        }
        result.success(false)
    }catch (e: Exception){
       result.error(Errors.ERROR_NOT_FOUND,"Something went wrong while getting packages details",null)
    }
}

fun Context.getDeviceInfo(result: Result){
    result.success(mutableMapOf<String,Any>().apply {
        put(Keys.DEVICE_NAME, Build.MODEL)
        put(Keys.DEVICE_BRAND, Build.BRAND)
        put(Keys.DEVICE_ID, Build.ID)
    })
}

fun Context.getAppInfo(result: Result) {
    val appInfo = packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA)
    try {
        result.success(mutableMapOf<String, Any>().apply {
            put(Keys.APP_IDENTIFIER, appInfo.packageName)
            put(Keys.TARGET_VERSION, appInfo.targetSdkVersion)
            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.O) {
                put(Keys.APP_CATEGORY, appInfo.category)
            }
        })
    }catch (e: Exception){
        result.error(Errors.ERROR_NOT_FOUND, "unable to fetch app details",null)
    }
}
