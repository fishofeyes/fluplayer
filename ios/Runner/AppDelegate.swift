import Flutter
import CoreTelephony
import appsflyer_sdk
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      guard let controller = window?.rootViewController as? FlutterViewController else {
                  fatalError("Invalid root view controller")
              }

      let deviceInfoChannel = FlutterMethodChannel(
          name: "com.sim.app/device_info",
          binaryMessenger: controller.binaryMessenger
      )
      deviceInfoChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
                // 处理来自 Dart 的 'checkForSIMCard' 方法调用
                if call.method == "haveSim" {
                    let hasSIM = CTTelephonyNetworkInfo().serviceCurrentRadioAccessTechnology?.count != 0
                    result(hasSIM) // 将结果返回给 Flutter
                } else {
                    // 如果收到未定义的 method call，返回 notImplemented
                    result(FlutterMethodNotImplemented)
                }
            }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        AppsFlyerAttribution.shared()!.handleOpenUrl(url, sourceApplication: sourceApplication, annotation: annotation);
        return true
    }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerAttribution.shared()!.handleOpenUrl(url, options: options)
        return true
    }
    
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        AppsFlyerAttribution.shared()!.continueUserActivity(userActivity, restorationHandler: nil)
        return true
    }

    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerAttribution.shared()!.continueUserActivity(userActivity, restorationHandler: nil)
        return true
     }
}
