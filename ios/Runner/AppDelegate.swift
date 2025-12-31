import Flutter
import FirebaseCore
import UIKit
import GoogleMaps
@main
@objc class AppDelegate: FlutterAppDelegate {

  private let channelName = "deep_link_channel"
  private var deepLinkChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  FirebaseApp.configure()
      GeneratedPluginRegistrant.register(with: self)
        GMSServices.provideAPIKey("AIzaSyDmrLzP5frPHCyYPbTM6Kdyu9STHcWl4as")
    let controller = window?.rootViewController as! FlutterViewController
    deepLinkChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    deepLinkChannel?.invokeMethod("onDeepLink", arguments: url.absoluteString)
    return true
  }

  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      deepLinkChannel?.invokeMethod("onDeepLink", arguments: url.absoluteString)
    }
    return true
  }
}
