package `in`.techbyvishesh.app_utils


import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AppUtilsPlugin */
class AppUtilsPlugin: FlutterPlugin, MethodCallHandler {

  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_utils")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method){

      Methods.LAUNCH_APP ->{
        context.launchApp(call.arguments as Map<String,Any>,result)
      }

      Methods.GET_INSTALLED_APPS ->{
        context.getInstalledApplications(result)
      }
      Methods.CAN_LAUNCH_APP -> {
        context.checkCanLaunchApp(call.arguments as Map<String,Any>,result)
      }
      Methods.GET_DEVICE_INFO-> {
        context.getDeviceInfo(result)
      }

      Methods.GET_APP_INFO -> {
        context.getAppInfo(result)
      }

      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
