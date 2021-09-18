abstract class AppSettings {
  final String settingsType;

  AppSettings(this.settingsType);

  Map<String, dynamic> toJson();
}

class AndroidSettings extends AppSettings {
  AndroidSettings({required AndroidSettingsType settings})
      : super(settings.toString());

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{"type": settingsType};
  }
}

class IOSSettings extends AppSettings {
  IOSSettings({required IOSSettignsType settings}) : super(settings.toString());

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{"type": settingsType};
  }
}

enum AndroidSettingsType {
  APPLICATION,
  WIFI,
  DATA_ROAM,
  LOCATION,
  BLUETOOTH,
  NOTIFICATION,
  SECURITY,
  SOUND,
  MAIN,
  DATE,
  ACCESSIBILITY,
  ACCOUNT,
  AIRPLANE_MODE,
  APN_SETTINGS,
  APPLICATION_DETAILS,
  DEVELOPMENT,
  NOTIFICATION_BUBBLE,
  APP_NOTIFICATION,
  SEARCH,
  BATTERY_SAVER,
  BIOMETRIC_ENROLL,
  CAPTIONING,
  CAST
}

///For iOS, Apple doesn't allow developers to open pref API
/// which is the only way to open a sub-settings page on your device <br>
/// If you use this API then your app will get rejected on AppStore.
/// <a  href ="https://developer.apple.com/forums/thread/100471">See here</a>
/// That's why this plugin only support of main settings page <br>
///
enum IOSSettignsType { MAIN }
