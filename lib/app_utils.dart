import 'dart:async';
import 'dart:io';
import 'package:app_utils/settings.dart';
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
  static const String OPEN_DEVICE_SETTINGS = "open_device_settings";

  ///method that launches open another application by using platform specific api's <br>
  ///[androidPackage] android appId, to get appId from playstore check playstore query param <b>?id=com.xyz</b> <br>
  ///[iosUrlScheme] iOS url scheme, to get url scheme check appilication docs.for example for whatsapp url scheme is <b>whatsapp://</b> <br>
  /// [launchStore] passed true then, it will launch application store from provided link if not installed on device <br>
  /// [playStoreUrl] appstore url for andorid <br>
  /// [appStoreUrl] appstore url for iOS <br>
  static Future<void> launchApp(
      {String androidPackage = "",
      String iosUrlScheme = "",
      bool? launchStore = false,
      String playStoreUrl = "",
      String appStoreUrl = "",
      Map<String,dynamic> params = const {}
      }) async {
    String identifier = Platform.isAndroid ? androidPackage : iosUrlScheme;
    String storeUrl = Platform.isAndroid ? playStoreUrl : appStoreUrl;
    await _channel.invokeMethod(LAUNCH_APP, {
      "appIdentifier": identifier,
      "storeUrl": storeUrl,
      "launchStore": launchStore,
      "data": params
    });
  }

  ///method that returns all device installed applications, <br>
  ///it List of [AppDetail] objects that contains all application information, <br>
  /// Note -: This method is supported only on Android platform <br>
  static Future<List<BundleInfo>> getInstalledApps() async {
    List<dynamic> listOfApps = await _channel.invokeMethod(GET_INSTALLED_APPS);
    return listOfApps
        .map((map) => BundleInfo.fromJson(map))
        .toList(growable: false);
  }

  ///method that checks is provided appication is or not, <br>
  ///[androidPackageName] applicationId for android, <br>
  ///[iOSUrlScheme] urlScheme for iOS, <br>
  ///return [bool] boolean status <br>
  static Future<bool?> canLaunchApp(
      {String androidPackageName = "", String iOSUrlScheme = ""}) async {
    final appIdentifier =
        Platform.isAndroid ? androidPackageName : iOSUrlScheme;
    return await _channel
        .invokeMethod(CAN_LAUNCH_APP, {"appIdentifier": appIdentifier});
  }


  /// returns current device details [DeviceInfo]
  static Future<DeviceInfo> getCurrentDeviceInfo() async {
    final deviceInfoJson =  await _channel.invokeMethod(GET_DEVICE_INFO);
    return DeviceInfo.fromJson(deviceInfoJson);
  }

  /// returns current app details [BundleInfo]
  static Future<BundleInfo> getCurrentAppInfo() async {
     final bundleJson = await _channel.invokeMethod(GET_APP_INFO);
     return BundleInfo.fromJson(bundleJson);
  }

  /// read sender application data
  static Future<Map<String,dynamic>> readLaunchedData() async {
    return (await _channel
                .invokeMethod<Map<dynamic, dynamic>>(READ_LAUNCHED_DATA))
            ?.map<String, dynamic>(
                (key, value) => MapEntry(key.toString(), value)) ??
        <String, dynamic>{};
  }

  /// Opens device settings.
  /// It takes platform specific settings object <br>
  /// [AndroidSettings] for android, [IOSSettings] for iOS
  static Future<void> openDeviceSettings(AppSettings platformSettings) async {
     await _channel.invokeMethod(OPEN_DEVICE_SETTINGS ,platformSettings.toJson());
  }

}
