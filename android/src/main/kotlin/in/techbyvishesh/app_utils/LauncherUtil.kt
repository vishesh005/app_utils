package `in`.techbyvishesh.app_utils

import APP_IDENTIFIER
import DATA
import DEFAULT_ERROR
import ERROR_NOT_FOUND
import LAUNCH_STORE
import STORE_URL
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*
import kotlin.collections.HashMap


fun Context.launchApp(args: Map<String, Any>, result: Result){
    val packageName = args[APP_IDENTIFIER] as String?
    val storeUrl = args[STORE_URL] as String?
    val isLaunchStore = args[LAUNCH_STORE] as Boolean?
    val data = args[DATA] as HashMap<String, *>?
    val launchIntent = packageManager?.getLaunchIntentForPackage(packageName.toString())
    if(launchIntent != null){
         val bundle = Bundle()
         bundle.putSerializable("bundle",data)
        launchIntent.putExtras(bundle)
        startActivity(launchIntent)
        result.success(true)
    }
    else{
        if(isLaunchStore == true){
            val openURL = Intent(Intent.ACTION_VIEW)
            openURL.data = Uri.parse(storeUrl)
            startActivity(openURL)
            result.success(true)
        }
        else{
            result.error(ERROR_NOT_FOUND,"Application isn't installed on your device",null)
        }
    }
}


fun Context.getInstalledApplications(result: Result){
    try {
        val packages = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
        val apps = packages.map { HashMap<String,Any>().apply {
            put(APP_IDENTIFIER, it.packageName)
        } }.toList()
        result.success(apps)
    } catch (e: Exception){
        result.error(DEFAULT_ERROR,"No able to query packages",null)
    }
}


fun Context.checkCanLaunchApp(args: Map<String, Any>, result: Result){
    try {
        val packageName = args[APP_IDENTIFIER].toString().trim()
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
       result.error(ERROR_NOT_FOUND,"Something went wrong while getting packages details",null)
    }
}
