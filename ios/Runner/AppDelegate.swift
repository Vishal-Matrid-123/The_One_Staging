// GoogleService-Info.plist
import UIKit
import Flutter
import Firebase
import FBSDKCoreKit
import Foundation
import FBAudienceNetwork
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {


    GeneratedPluginRegistrant.register(with: self)
      FirebaseApp.initialize()
      Firebase.Analytics.setAnalyticsCollectionEnabled(true)

    AppEvents.shared.activateApp()

      FBAdSettings.setAdvertiserTrackingEnabled(true)
     
      if(UserDefaults.standard.string(forKey: "isFirstTime") == nil){
          UserDefaults.standard.removeObject(forKey: "userName");
          UserDefaults.standard.removeObject(forKey: "userId");
          UserDefaults.standard.removeObject(forKey: "email");
          UserDefaults.standard.removeObject(forKey: "guestCustomerID");
          UserDefaults.standard.removeObject(forKey: "userId");
          UserDefaults.standard.removeObject(forKey: "guestGUID");
          UserDefaults.standard.removeObject(forKey: "phone");
          UserDefaults.standard.removeObject(forKey: "guestGUID");
          UserDefaults.standard.removeObject(forKey: "sepGuid");
          UserDefaults.standard.removeObject(forKey: "apiTokken");
          UserDefaults.standard.set("Val", forKey: "isFirstTime")
          print("Values reset");
      }else{
          print("Values available for Key>> isFirstTime");
      }


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

