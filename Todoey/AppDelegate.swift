



import UIKit

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
      //  print(Realm.Configuration.defaultConfiguration.fileURL)
        do {
        let _ = try Realm()
        }catch {
            print("error accessing Realm,  \(error)")
        }

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
  
    }
}
    
     
