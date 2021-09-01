
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'app_detail.dart';

class AppUtils {
  static const MethodChannel _channel =
      const MethodChannel('app_utils');

  static const String LAUNCH_APP = "launch_app";
  static const String GET_INSTALLED_APPS = "get_installed_apps";
  static const String CAN_LAUNCH_APP = "can_launch_app";

  static Future<void> launchApp({
    String androidPackage = "",
    String iosUrlScheme = "",
    bool? launchStore = false,
    String playStoreUrl = "",
    String appStoreUrl = ""
  }) async {
    String identifier = Platform.isAndroid ? androidPackage : iosUrlScheme;
    String storeUrl = Platform.isAndroid ? playStoreUrl : appStoreUrl;
    _channel.invokeListMethod(LAUNCH_APP, {
      "appIdentifier" : identifier,
      "storeUrl" : storeUrl,
      "launchStore" : launchStore
    });
  }

  static Future<List<AppDetail>> getInstalledApps() async {
    List<dynamic> listOfApps = await  _channel.invokeMethod(GET_INSTALLED_APPS);
    return listOfApps.map((map) => AppDetail.fromJson(map)).toList(growable: false);
  }

  static Future<bool?> canLaunchApp({
    String androidPackageName = "",
    String iOSUrlScheme = ""
  }) async {
    final appIdentifier = Platform.isAndroid ? androidPackageName : iOSUrlScheme;
    return await  _channel.invokeMethod(CAN_LAUNCH_APP, {
      "appIdentifier" :  appIdentifier
    });
  }

}
