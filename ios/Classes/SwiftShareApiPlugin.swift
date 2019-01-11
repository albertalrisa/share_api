import Flutter
import UIKit
    
public class SwiftShareApiPlugin: NSObject, FlutterPlugin {
    
    let intents = [
        "facebook": Facebook(),
        "instagram": Instagram()
    ] as [String: ShareIntent]
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.albertalrisa.flutter.plugins/share_api", binaryMessenger: registrar.messenger())
    let instance = SwiftShareApiPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch(call.method) {
    case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
    case "share":
        self.share(call.arguments, result: result)
    case "isInstalled":
        self.isInstalled(call.arguments, result: result)
    default:
        result(FlutterMethodNotImplemented)
    }
    
  }
    
    private func share(_ arguments: Any?, result: @escaping FlutterResult) {
        let args = arguments as! Dictionary<String, Any?>
        let handler = args["handler"] as! Dictionary<String, String>
        let module = handler["module"] ?? ""
        if intents.keys.contains(module) {
            let intent = intents["module"]!
            let function = handler["function"] ?? ""
            if let functionArguments = args["arguments"] {
                do {
                    try intent.execute(function: function, arguments: functionArguments as! Dictionary<String, String>, result: result)
                } catch {
                    result(FlutterError(code: "SharingException", message: "Sharing to module \(module) failed", details: ""))
                }
            }
            else {
                result(FlutterError(code: "InvalidArgument", message: "Arguments must be of type Map<String, String>", details: args["arguments"] ?? ""))
            }
        }
        else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func isInstalled(_ arguments: Any?, result: @escaping FlutterResult) {
        let args = arguments as! Dictionary<String, Any?>
        let handler = args["handler"] as! Dictionary<String, String>
        let module = handler["module"] ?? ""
        if intents.keys.contains(module) {
            let status: Bool = intents[module]!.isPackageInstalled()
            result(status)
        }
        else {
            result(false)
        }
    }
}
