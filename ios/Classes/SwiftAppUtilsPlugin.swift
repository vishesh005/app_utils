import Flutter
import UIKit

public class SwiftAppUtilsPlugin: NSObject, FlutterPlugin, FlutterApplicationLifeCycleDelegate {
    
    var params : [URLQueryItem] = []
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "app_utils", binaryMessenger: registrar.messenger())
        let instance = SwiftAppUtilsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func application(_ application: UIApplication,
                            open url: URL,
                            options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        let sendingAppID = options[.sourceApplication]
        print("application = \(sendingAppID ?? "nil")")
        
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                let path = components.path,
                let params = components.queryItems else {
                    print("Invalid URL or path missing")
                    return false
            }
        print(path)
        self.params =  params
        return true
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case LAUNCH_APP:
            launchApp(
                arguments: call.arguments,
                result: result
            )
            break
        case GET_INSTALLED_APPS:
            result([])
            break
        case CAN_LAUNCH_APP:
            checkCanLaunch(
                arguments: call.arguments,
                result: result
            )
            break
        case GET_DEVICE_INFO:
            getDeviceInfo(result: result)
            break
        case GET_APP_INFO:
            getAppInfo(result: result)
            break
        case READ_LAUNCHED_DATA:
            readlaunchedData(result: result,params: params)
            break
        case OPEN_DEVICE_SETTINGS:
            openDeviceSettings(arguments: call.arguments,
                               result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
