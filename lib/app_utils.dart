import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'models.dart';

///Class that manages all app_utils operations
class AppUtils {
  static const MethodChannel _channel = const MethodChannel('app_utils');

  static const String LAUNCH_APP = "launch_app";
  static const String GET_INSTALLED_APPS = "get_installed_apps";
  static const String CAN_LAUNCH_APP = "can_launch_app";
  static const String GET_DEVICE_INFO = "get_device_info";
  static const String GET_APP_INFO = "get_app_info";
  static const String READ_LAUNCHED_DATA = "read_launched_data";

  ///method that launches open another application by using platform specific api's
  ///[androidPackage] android appId, to get appId from playstore check playstore query param <b>?id=com.xyz</b>
  ///[iosUrlScheme] iOS url scheme, to get url scheme check appilication docs.for example for whatsapp url scheme is <b>whatsapp://</b>
  /// [launchStore] passed true then, it will launch application store from provided link if not installed on device
  /// [playStoreUrl] appstore url for andorid
  /// [appStoreUrl] appstore url for iOS
  static Future<void> launchApp(
      {String androidPackage = "",
      String iosUrlScheme = "",
      bool? launchStore = false,
      String playStoreUrl = "",
      String appStoreUrl = ""}) async {
    String identifier = Platform.isAndroid ? androidPackage : iosUrlScheme;
    String storeUrl = Platform.isAndroid ? playStoreUrl : appStoreUrl;
    await _channel.invokeMethod(LAUNCH_APP, {
      "appIdentifier": identifier,
      "storeUrl": storeUrl,
      "launchStore": launchStore
    });
  }

  ///method that returns all device installed applications,
  ///it List of [AppDetail] objects that contains all application information,
  /// Note -: This method is supported only on Android platform
  static Future<List<BundleInfo>> getInstalledApps() async {
    List<dynamic> listOfApps = await _channel.invokeMethod(GET_INSTALLED_APPS);
    return listOfApps
        .map((map) => BundleInfo.fromJson(map))
        .toList(growable: false);
  }

  ///Method that checks is provided appication can launch or not
  ///[androidPackageName] applicationId for android
  ///[iOSUrlScheme] urlScheme for iOS
  ///return [bool] boolean status
  static Future<bool?> canLaunchApp(
      {String androidPackageName = "", String iOSUrlScheme = ""}) async {
    final appIdentifier =
        Platform.isAndroid ? androidPackageName : iOSUrlScheme;
    return await _channel
        .invokeMethod(CAN_LAUNCH_APP, {"appIdentifier": appIdentifier});
  }


  static Future<DeviceInfo> getCurrentDeviceInfo() async {
    final deviceInfoJson =  await _channel.invokeMethod(GET_DEVICE_INFO);
    return DeviceInfo.fromJson(deviceInfoJson);
  }

  static Future<BundleInfo> getCurrentAppInfo() async {
     final bundleJson = await _channel.invokeMethod(GET_APP_INFO);
     return BundleInfo.fromJson(bundleJson);
  }


  static Future<Map<String,dynamic>> readLaunchedData() async {
     return await _channel.invokeMethod(READ_LAUNCHED_DATA);
  }


}
