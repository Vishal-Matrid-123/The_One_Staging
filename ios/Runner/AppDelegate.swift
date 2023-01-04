// GoogleService-Info.plist
import UIKit
import Flutter
import Firebase
import FBSDKCoreKit
import FBSDKCoreKit.FBSDKSettings

import FBAudienceNetwork
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
//     didRegisterForRemoteNotificationWithDeviceToken deviceToken : Data
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

//   if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
//          // Delete values from keychain here
//
//          [[NSUserDefaults standardUserDefaults] setValue:@"1strun" forKey:@"FirstRun"];
//          [[NSUserDefaults standardUserDefaults] synchronize];
//      }

      
//      UserDefaults default = UserDefaults()

      
//       Messaging.messaging().apnsToken=deviceToken
    GeneratedPluginRegistrant.register(with: self)
      FirebaseApp.initialize()
//      FirebaseApp.configure(op)
      Firebase.Analytics.setAnalyticsCollectionEnabled(true)

    AppEvents.shared.activateApp()
//      FsetAdvertiserTrackingEnabled(true)
//      FBSDKCoreKit.Settings.enableLoggingBehavior(self)
//      FBSDKCoreKit.Settings.setAdvertiserTrackingEnabled(true)
      
//      FBSDKCoreKit.Se
      FBAdSettings.setAdvertiserTrackingEnabled(true)
     


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override  func application(
             _ app: UIApplication,
             open url: URL,
             options: [UIApplication.OpenURLOptionsKey : Any] = [:]
         ) -> Bool {

             ApplicationDelegate.shared.application(
                 app,
                 open: url,
                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                 annotation: options[UIApplication.OpenURLOptionsKey.annotation]
             )

         }
  }
              private func setExcludeFromiCloudBackup(isExcluded: Bool) throws {
                  var fileOrDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                  var values = URLResourceValues()
                  values.isExcludedFromBackup = isExcluded
                  try fileOrDirectoryURL.setResourceValues(values)
              }

// two files of same name

//Last one is latest
