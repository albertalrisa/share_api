#import "ShareApiPlugin.h"
#import <share_api/share_api-Swift.h>

@implementation ShareApiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftShareApiPlugin registerWithRegistrar:registrar];
}
@end
