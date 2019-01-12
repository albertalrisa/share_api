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
        self.share(call.arguments as? Dictionary<String, Any?>, result: result)
    case "isInstalled":
        self.isInstalled(call.arguments as? Dictionary<String, Any?>, result: result)
    default:
        result(FlutterMethodNotImplemented)
    }
  }
    
    private func share(_ callArguments: Dictionary<String, Any?>?, result: @escaping FlutterResult) {
        if let args = callArguments {
            let handler = args["handler"] as! Dictionary<String, String>
            let module = handler["module"] ?? ""
            if intents.keys.contains(module) {
                let intent = intents[module]!
                let function = handler["function"] ?? ""
                if let functionArguments = args["arguments"] {
                    let fnArgs = functionArguments as! Dictionary<String, String?>
                    intent.execute(function: function, arguments: fnArgs, result: result)
                }
                else {
                    result(FlutterError(code: "InvalidArgument", message: "Arguments must be of type Dictionary<String, String>", details: args["arguments"] ?? ""))
                }
//                let functionArguments = args["arguments"] as! Dictionary<String, String>
//                print(functionArguments)
//                print(args["arguments"])
//                if let fnArgs = functionArguments {
////                    do {
//                        intent.execute(function: function, arguments: fnArgs, result: result)
////                    } catch {
////                        result(FlutterError(code: "SharingException", message: "Sharing to module \(module) failed", details: ""))
////                    }
//                }
            }
            else {
                result(FlutterMethodNotImplemented)
            }
        }
        else {
            result(FlutterError(code: "Invalid method call", message: "Method is called without passing any arguments", details: callArguments ?? ""))
        }
    }
    
    private func isInstalled(_ callArguments: Dictionary<String, Any?>?, result: @escaping FlutterResult) {
        if let args = callArguments {
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
        else {
             result(FlutterError(code: "Invalid method call", message: "Method is called without passing any arguments", details: callArguments ?? ""))
        }
    }
}
