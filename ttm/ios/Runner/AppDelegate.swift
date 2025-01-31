import UIKit
import Flutter
import GoogleMaps // Import Google Maps SDK

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Provide your Google Maps API key (Make sure it's valid and enabled for Maps SDK)
    GMSServices.provideAPIKey("AIzaSyByh8kxXcO3Q2_aPOQ0wZU0rSncLaWSlBQ") // Replace with your actual API key

    let controller = window?.rootViewController as! FlutterViewController
    let streetViewChannel = FlutterMethodChannel(name: "com.ttm.streetview", binaryMessenger: controller.binaryMessenger)

    streetViewChannel.setMethodCallHandler { (call, result) in
        if call.method == "launchStreetView" {
            if let args = call.arguments as? [String: Any],
               let latitude = args["latitude"] as? Double,
               let longitude = args["longitude"] as? Double {
                self.launchStreetView(latitude: latitude, longitude: longitude)
                result(true)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Latitude and longitude are required", details: nil))
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Launches Google Street View using Google Maps URL Scheme
  private func launchStreetView(latitude: Double, longitude: Double) {
      let url = URL(string: "comgooglemaps://?cbll=\(latitude),\(longitude)&layer=c")!
      if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
          print("Google Maps app is not installed")
      }
  }
}
