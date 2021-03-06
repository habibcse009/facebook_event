import Flutter
import UIKit
import FBSDKCoreKit

public class SwiftFacebookAppEventsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.faisal/facebook_event", binaryMessenger: registrar.messenger())
        let instance = SwiftFacebookAppEventsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "clearUserData":
            handleClearUserData(call, result: result)
            break
        case "clearUserID":
            handleClearUserID(call, result: result)
            break
        case "flush":
            handleFlush(call, result: result)
            break
        case "getApplicationId":
            handleGetApplicationId(call, result: result)
            break
        case "logEvent":
            handleLogEvent(call, result: result)
            break
        case "logPushNotificationOpen":
            handlePushNotificationOpen(call, result: result)
            break
        case "setUserData":
            handleSetUserData(call, result: result)
            break
        case "setUserID":
            handleSetUserId(call, result: result)
            break
        case "updateUserProperties":
            handleUpdateUserProperties(call, result: result)
            break
        case "setAutoLogAppEventsEnabled":
            handleSetAutoLogAppEventsEnabled(call, result: result)
            break
        case "setDataProcessingOptions":
            handleSetDataProcessingOptions(call, result: result)
            break
        case "logPurchase":
            handlePurchased(call, result: result)
            break
        case "logAchieveLevelEvent":
            logAchieveLevelEvent(call, result: result)
            break
        case "getAnonymousId":
            handleHandleGetAnonymousId(call, result: result)
            break
        case "logAddPaymentInfoEvent":
            logAddPaymentInfoEvent(call, result: result)
            break
        case "logAddToCartEvent":
            logAddToCartEvent(call, result: result)
            break
        case "logCompleteRegistrationEvent":
            logCompleteRegistrationEvent(call, result: result)
            break
        case "logInitiateCheckoutEvent":
            logInitiateCheckoutEvent(call, result: result)
            break
        case "logRateEvent":
            logRateEvent(call, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleClearUserData(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        AppEvents.clearUserData()
        result(nil)
    }

    private func handleClearUserID(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        AppEvents.clearUserID()
        result(nil)
    }

    private func handleFlush(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        AppEvents.flush()
        result(nil)
    }

    private func handleGetApplicationId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(Settings.appID)
    }

    private func handleHandleGetAnonymousId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(AppEvents.anonymousID)
    }

    private func handleLogEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let eventName = arguments["name"] as! String
        let parameters = arguments["parameters"] as? [String: Any] ?? [String: Any]()
        if arguments["_valueToSum"] != nil && !(arguments["_valueToSum"] is NSNull) {
            let valueToDouble = arguments["_valueToSum"] as! Double
            AppEvents.logEvent(AppEvents.Name(eventName), valueToSum: valueToDouble, parameters: parameters)
        } else {
            AppEvents.logEvent(AppEvents.Name(eventName), parameters: parameters)
        }

        result(nil)
    }

    private func handlePushNotificationOpen(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let payload = arguments["payload"] as? [String: Any]
        if let action = arguments["action"] {
            let actionString = action as! String
            AppEvents.logPushNotificationOpen(payload!, action: actionString)
        } else {
            AppEvents.logPushNotificationOpen(payload!)
        }

        result(nil)
    }

    private func handleSetUserData(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        AppEvents.setUserData(arguments["email"] as? String, forType: AppEvents.UserDataType.email)
        AppEvents.setUserData(arguments["firstName"] as? String, forType: AppEvents.UserDataType.firstName)
        AppEvents.setUserData(arguments["lastName"] as? String, forType: AppEvents.UserDataType.lastName)
        AppEvents.setUserData(arguments["phone"] as? String, forType: AppEvents.UserDataType.phone)
        AppEvents.setUserData(arguments["dateOfBirth"] as? String, forType: AppEvents.UserDataType.dateOfBirth)
        AppEvents.setUserData(arguments["gender"] as? String, forType: AppEvents.UserDataType.gender)
        AppEvents.setUserData(arguments["city"] as? String, forType: AppEvents.UserDataType.city)
        AppEvents.setUserData(arguments["state"] as? String, forType: AppEvents.UserDataType.state)
        AppEvents.setUserData(arguments["zip"] as? String, forType: AppEvents.UserDataType.zip)
        AppEvents.setUserData(arguments["country"] as? String, forType: AppEvents.UserDataType.country)

        result(nil)
    }

    private func handleSetUserId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let id = call.arguments as! String
        AppEvents.userID = id
        result(nil)
    }

    private func handleUpdateUserProperties(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let parameters =  arguments["parameters"] as! [String: Any]

        AppEvents.updateUserProperties( parameters, handler: { (connection, response, error) in
            if error != nil {
                result(nil)
            } else {
                result(response)
            }
        })
    }

    private func handleSetAutoLogAppEventsEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let enabled = call.arguments as! Bool
        Settings.isAutoLogAppEventsEnabled = enabled
        result(nil)
    }

    private func handleSetDataProcessingOptions(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let modes = arguments["options"] as? [String] ?? []
        let state = arguments["state"] as? Int32 ?? 0
        let country = arguments["country"] as? Int32 ?? 0

        Settings.setDataProcessingOptions(modes, country: country, state: state)

        result(nil)
    }

    private func handlePurchased(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let amount = arguments["amount"] as! Double
        let currency = arguments["currency"] as! String
        let parameters = arguments["parameters"] as? [String: Any] ?? [String: Any]()
        AppEvents.logPurchase(amount, currency: currency, parameters: parameters)

        result(nil)
    }

    private func logAchieveLevelEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let parameters = [
            AppEvents.ParameterName.level.rawValue: arguments["level"] as! String
        ]

        AppEvents.logEvent(.achievedLevel, parameters: parameters)
        result(nil)
    }

    private func logAddPaymentInfoEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let parameters = [
            "success": arguments["success"] as! Bool ? 1 : 0
        ]
        AppEvents.logEvent(.addedPaymentInfo, parameters: parameters)
        result(nil)
    }
    
    private func logAddToCartEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let parameters = [
            AppEvents.ParameterName.content.rawValue: arguments["contentData"] as!String,
            AppEvents.ParameterName.contentID.rawValue: arguments["contentId"] as!String,
            AppEvents.ParameterName.contentType.rawValue: arguments["contentType"] as!String,
            AppEvents.ParameterName.currency.rawValue: arguments["currency"] as!String
        ]

        AppEvents.logEvent(.addedToCart, valueToSum: arguments["price"] as!Double, parameters: parameters)
        result(nil)
    }
    private func logCompleteRegistrationEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let parameters = [
            AppEvents.ParameterName.registrationMethod.rawValue:arguments["registrationMethod"] as!String,
            "fb_mobile_complete_registration":arguments["name"] as!String,
            "fb_currency":arguments["currency"] as!String
        ]

        AppEvents.logEvent(.completedRegistration, parameters: parameters)
        result(nil)
    }
    private func logInitiateCheckoutEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let totalPrice = arguments["totalPrice"] as! Double
        let parameters : [String:Any] = [
                AppEvents.ParameterName.content.rawValue: arguments["contentData"] as!String,
                AppEvents.ParameterName.contentID.rawValue: arguments["contentId"] as!String,
                AppEvents.ParameterName.contentType.rawValue: arguments["contentType"] as!String,
                AppEvents.ParameterName.currency.rawValue: arguments["currency"] as!String,
                "itemCount": arguments["numItems"]as? String ?? "1",
                AppEvents.ParameterName.paymentInfoAvailable.rawValue: NSNumber(value: arguments["paymentInfoAvailable"] as! Bool ? 1 : 0),
            ]

        AppEvents.logEvent(.initiatedCheckout, valueToSum: totalPrice, parameters: parameters)
        result(nil)
    }
    private func logRateEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let maxRatingValue = arguments["maxRatingValue"] as! Int32
        let ratingGiven = arguments["ratingGiven"] as! Double
        let parameters : [String:Any] = [
                AppEvents.ParameterName.content.rawValue: arguments["contentData"] as!String,
                AppEvents.ParameterName.contentID.rawValue: arguments["contentId"] as!String,
                AppEvents.ParameterName.contentType.rawValue: arguments["contentType"] as!String,
                AppEvents.ParameterName.maxRatingValue.rawValue: NSNumber(value:maxRatingValue)
            ]

            AppEvents.logEvent(.rated, valueToSum: ratingGiven, parameters: parameters)
        result(nil)
    }
}
