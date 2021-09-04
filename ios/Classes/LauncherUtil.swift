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
        let urlScheme = args[APP_IDENTIFIER] as! String? ?? ""
        let storeUrl = args[STORE_URL] as! String? ?? ""
        let isLaunchStore = args[LAUNCH_STORE] as! Bool?
        let data = args[DATA] as! Dictionary<String,Any>?
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
        DEVICE_ID : UIDevice.current.identifierForVendor?.uuidString
       ]
       result(dictionary)
    }

    func getAppInfo(result: FlutterResult) {
       let dictionary = [
        APP_IDENTIFIER : Bundle.main.bundleIdentifier
       ]
        result(dictionary)
    }
    
}

