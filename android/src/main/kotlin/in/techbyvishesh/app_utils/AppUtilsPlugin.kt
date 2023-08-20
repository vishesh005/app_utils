package `in`.techbyvishesh.app_utils


import android.content.Context
import android.content.Intent
import android.media.MediaPlayer
import android.widget.Toast
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AppUtilsPlugin */
class AppUtilsPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var intent: Intent
  private var mediaPlayer: MediaPlayer?

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

      Methods.READ_LAUNCHED_DATA->{
         context.readLaunchedData(result,intent)
      }

      Methods.OPEN_DEVICE_SETTINGS ->{
         context.openDeviceSettings(call.arguments as Map<String,Any>,result)
      }

      Methods.PLAY_AUDIO -> {
         if(mediaPlayer === null){
            mediaPlayer = MediaPlayer();
         }
         mediaPlayer?.reset()
         mediaPlayer?.setDataSource("")

      }

      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
      intent = binding.activity.intent
  }

  override fun onDetachedFromActivityForConfigChanges() = Unit

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = Unit

  override fun onDetachedFromActivity() {
      mediaPlayer?.release(); // Releasing the MediaPlayer resources
  }
}
