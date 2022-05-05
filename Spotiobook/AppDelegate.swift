
import UIKit
import Firebase
import FirebaseStorage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//  let storage = Storage.storage()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
  
//  func getData(completionHandler: (Int) -> Void){
//    let gs = storage.reference(forURL: "gs://spotiobook.appspot.com/business.csv")
////    let ref = gs.child("business.csv")
//    var x = gs.getData(maxSize: 10000000000) { data, error in
//      if let error = error {
//        print("ERROR", error)
//      } else {
//        print("HERE")
//        print("Data: \(data!)")
//      }
//    }
//  }
}
