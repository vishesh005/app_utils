///class that holds queried application bundle information
class BundleInfo {
  final String appName;
  final String appIdentifier;
  final String version;
  final String buildNo;

  BundleInfo(this.appName, this.appIdentifier, this.version, this.buildNo);

  static BundleInfo fromJson(dynamic json) {
    return BundleInfo(
        json["appName"] ?? 'null',
        json["appIdentifier"] ?? 'null',
        json["version"] ?? 'null',
        (json["buildNo"] ?? 'null').toString());
  }
}

class DeviceInfo{
  String name;
  String brand;
  String osVersion;
  String id;

  DeviceInfo(this.name,this.brand,this.id,this.osVersion);

  static DeviceInfo fromJson(dynamic json){
     return DeviceInfo(
       json["deviceName"],
       json["deviceBrand"],
       json["deviceId"],
       json["osVersion"]
     );
  }
}
