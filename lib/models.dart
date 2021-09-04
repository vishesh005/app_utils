///class that holds queried application bundle information
class BundleInfo {
  final String appIdentifier;
  final int targetVersion;
  final int? category;

  BundleInfo(this.appIdentifier,this.targetVersion,{this.category});

  static BundleInfo fromJson(dynamic json) {
    return BundleInfo(
        json["appIdentifier"],
        json["targetVersion"],
        category: json["appCategory"]
    );
  }
}

class DeviceInfo{
  String name;
  String brand;
  String id;

  DeviceInfo(this.name,this.brand,this.id);

  static DeviceInfo fromJson(dynamic json){
     return DeviceInfo(
       json["deviceName"],
       json["deviceBrand"],
       json["deviceId"]
     );
  }
}


