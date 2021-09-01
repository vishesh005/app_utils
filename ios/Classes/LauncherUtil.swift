//
//  LauncherUtil.swift
//  app_launcher_pro
//
//  Created by Vishesh on 17/08/21.
//

import Foundation


extension SwiftAppLauncherProPlugin {
    
    
    func checkCanLaunch(args arguments: Any?,
                        flutterResult result : FlutterResult){
        let args = arguments as! Dictionary<String,Any>
        let urlScheme = args[APP_IDENTIFIER] as! String?
        let storeUrl = args[STORE_URL] as! String?
        let isLaunchStore = args[LAUNCH_STORE] as! Bool?
        let data = args[DATA] as! Dictionary<String,Any>?
        if let url = URL(string: urlScheme ?? ""){
            if(UIApplication.shared.canOpenURL(url)){
                UIApplication.shared.openURL(url)
                result(nil)
            }
            else{
                if(isLaunchStore == true){
                    if let url :URL = URL(string:storeUrl ?? ""){
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
    
    func launchApp(arguments args: Any?,flutterResult result : FlutterResult){
        
    }
    
    
    
}

