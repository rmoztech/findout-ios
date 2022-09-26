import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  FirebaseApp.configure()
      GeneratedPluginRegistrant.register(with: self)

          GMSServices.provideAPIKey("AIzaSyCPWWKQjByYNMe_eYgC9Ojb4-u6LgU6RRY")
                        if #available(iOS 10.0, *) {
                                    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
                                } else {
                                    // Fallback on earlier versions
                                }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
