import Foundation


extension SwiftAppUtilsPlugin {
    
    
    func checkCanLaunch(arguments: Any?, result : FlutterResult){
        let args = arguments as! Dictionary<String,Any>
        let urlScheme = args[APP_IDENTIFIER] as! String
        let url = URL(string: urlScheme)
        let canLaunch = UIApplication.shared.canOpenURL(url!)
        result(canLaunch)
    }
    
    
    func launchApp(arguments: Any?,result : FlutterResult){
        let args = arguments as! Dictionary<String,Any>
        var urlScheme = args[APP_IDENTIFIER] as! String? ?? ""
        let storeUrl = args[STORE_URL] as! String? ?? ""
        let isLaunchStore = args[LAUNCH_STORE] as! Bool?
        let data = args[DATA] as! Dictionary<String,Any>? ?? [:]
        var builder = ""
         for value in data {
           builder.append("\(value.key)=\(value.value)&&")
          }
          if(builder.contains("&&")){
              builder = String(builder.dropLast(2))
          }
        if(!builder.isEmpty){
            urlScheme = "\(urlScheme)?\(builder)"
        }
        if let url = URL(string: urlScheme){
            if(UIApplication.shared.canOpenURL(url)){
                UIApplication.shared.openURL(url)
                result(nil)
            }
            else{
                if(isLaunchStore == true){
                    if let url :URL = URL(string:storeUrl){
                    UIApplication.shared.openURL(url)
                    result(nil)
                   }
                }
                else{
                    result(FlutterError(
                     code: ERROR_NOT_FOUND,
                     message: "",
                     details: nil
                    ))
                }
            }
        }
    }
    
    
    func getDeviceInfo(result: FlutterResult){
       let dictionary = [
        DEVICE_NAME : UIDevice.current.name,
        DEVICE_BRAND : "Apple",
        DEVICE_ID : UIDevice.current.identifierForVendor?.uuidString,
        OS_VERSION :UIDevice.current.systemVersion
       ]
       result(dictionary)
    }

    func getAppInfo(result: FlutterResult) {
        let dictionary : Dictionary<String,Any?> = [
            APP_IDENTIFIER : Bundle.main.bundleIdentifier,
            APP_NAME : Bundle.main.infoDictionary?["CFBundleDisplayName"] ?? "",
            VERSION : Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "",
            BUILD_NO : Bundle.main.infoDictionary?["CFBundleVersion"]
        ]
        result(dictionary)
    }
    
    func  readlaunchedData(result: FlutterResult, params: [URLQueryItem]){
        var dictionary : Dictionary<String,Any> = [:]
        for item in params {
            dictionary[item.name] = item.value
        }
        result(dictionary)
    }
    
    
    func openDeviceSettings(arguments: Any?,result: FlutterResult) {
        let args = arguments as! Dictionary<String,Any>
        let type = args[TYPE] as! String
        let uri = getUriFromType(type: type)
        UIApplication.shared.openURL(uri)
    }
    
    private func getUriFromType(type : String) -> URL{
//        let settings = type.replacingOccurrences(of: "IOSSettings.", with: "", options: .literal, range: nil)
        return URL(string: UIApplication.openSettingsURLString)!
    }
}

