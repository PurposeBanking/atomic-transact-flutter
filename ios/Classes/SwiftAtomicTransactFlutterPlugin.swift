import Flutter
import UIKit
import AtomicTransact

public class SwiftAtomicTransactFlutterPlugin: NSObject, FlutterPlugin {
    
    let channel: FlutterMethodChannel;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "atomic_transact_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftAtomicTransactFlutterPlugin(withChannel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    init(withChannel channel: FlutterMethodChannel) {
        self.channel = channel;
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
          
        case "presentTransact":
            let arguments = call.arguments as! [String: Any]
            let environment = transactEnvironmentFromString(arguments["environment"] as? String);
            
            if let configuration = arguments["configuration"] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: configuration, options: [])
                    let config = try JSONDecoder().decode(AtomicConfig.self, from: data)
                    
                    if let controller = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
                        Atomic.presentTransact(from: controller, config: config, environment: environment,
                                               onInteraction: onInteraction, onDataRequest: onDataRequest, onCompletion: onCompletion)
                        result(nil)
                    } else {
                        result(FlutterError(code: "PlatformError", message: "No keyWindow found", details: nil))
                    }
                } catch let error {
                    result(FlutterError(code: "ConfigError", message: String(describing: error), details: nil))
                }
            }
            break;

        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Transact Delegate
    
    func onInteraction(_ interaction: TransactInteraction) {
        self.channel.invokeMethod("onInteraction", arguments: ["interaction": mapFromTransactInteraction(interaction)])
    }
    
    func onDataRequest(_ request: TransactDataRequest) {
        self.channel.invokeMethod("onDataRequest", arguments: ["request": mapFromTransactDataRequest(request)])
    }
    
    func onCompletion(_ response: TransactResponse) {
        var arguments : Any?;
        
        switch response {
            case .finished(let value):
                arguments = ["type": "finished", "response": mapFromTransactResponseData(value)];
            
            case .closed(let value):
                arguments = ["type": "closed", "response": mapFromTransactResponseData(value)];
            
            case .error(let error):
                var code: String;
                
                switch error {
                    case .invalidConfig:
                        code = "invalidConfig"
                    case .unableToConnectToTransact:
                        code = "unableToConnectToTransact"
                    default:
                        code = "unknownError";
                        break;
                }
            
                arguments = ["type": "error", "error": code];

            default:
                break;
        }
        
        if(arguments != nil) {
            self.channel.invokeMethod("onCompletion", arguments: arguments)
        }
    }
    
    // MARK: - Helpers
    
    func transactEnvironmentFromString(_ value: String?) -> TransactEnvironment {
        switch (value) {
            case "sandbox":
                return TransactEnvironment.sandbox
            case "production":
                return TransactEnvironment.production
            default:
                return TransactEnvironment.production
        }
    }
    
    func mapFromTransactInteraction(_ value: TransactInteraction) -> [String: Any?] {
        return [
            "name" : value.name,
            "description" : value.description,
            "data" : value.data,
            "language" : value.language,
            "company" : value.company,
            "customer" : value.customer,
            "payroll" : value.payroll,
            "product" : value.product?.rawValue,
            "additionalProduct" : value.additionalProduct?.rawValue,
        ]
    }
    
    func mapFromTransactDataRequest(_ value: TransactDataRequest) -> [String: Any?] {
        return [
            "fields": value.fields,
            "data": value.data,
            "userId": value.userId,
            "taskId": value.taskId,
        ];
    }
    
    func mapFromTransactResponseData(_ value: TransactResponse.ResponseData) -> [String: Any?] {
        return [
            "taskId": value.taskId,
            "data": value.data,
            "handoff": value.handoff,
            "reason": value.reason,
        ];
    }
}
