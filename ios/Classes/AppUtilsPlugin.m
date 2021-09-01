#import "AppUtilsPlugin.h"
#if __has_include(<app_utils/app_utils-Swift.h>)
#import <app_utils/app_utils-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "app_utils-Swift.h"
#endif

@implementation AppUtilsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppUtilsPlugin registerWithRegistrar:registrar];
}
@end
