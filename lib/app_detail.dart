///class that holds queried application information
class AppDetail {
  final String appIdentifier;

  AppDetail(this.appIdentifier);

  static AppDetail fromJson(dynamic json) {
    return AppDetail(json["appIdentifier"]);
  }
}
