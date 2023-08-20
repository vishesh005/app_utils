class AuthSettings {

  String? authType;
  final String title;
  final String description;

    AuthSettings(AuthType authType, this.title, this.description){
      this.authType = '$authType'.replaceFirst('AuthType.', '');
  }

  Map<String, dynamic> toJson(){
    return {
      "authType": this.authType,
      "title": this.title,
      "description": this.description
    };
  }


  static AuthSettings fromJson(Map<String,dynamic> map){
    final authType = AuthType.values.firstWhere((element) =>
    "$element".replaceFirst('AuthType.', '')  == map["authType"], orElse: ()=> AuthType.ANY);
    return AuthSettings(
        authType,
        map["title"],
        map["description"]);
  }


}


enum AuthType {
   ANY, PIN, PATTERN, FINGERPRINT, FACE
}