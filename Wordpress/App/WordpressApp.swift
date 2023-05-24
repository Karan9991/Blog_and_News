//
//  NewsApp.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI
import Firebase
import CoreData
import Firebase
import FirebaseInstanceID
import Alamofire
import SwiftyJSON
import UserNotifications
import Envato

@main
struct WordpressApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @ObservedObject var mainViewModel = MainViewModel()
    @ObservedObject var monitor = NetworkMonitorModel()
    
    @State var showMenu = false
    @State var showPage = false
    @State var page : Page?
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
            }else{
                ZStack{
                    
                    if monitor.isConnected {
                        // Menu...
                        NavigationMenuView(show: $showMenu, showPage: $showPage, page: $page)
                            .environmentObject(mainViewModel)
                        
                        MainView(showMenu: $showMenu)
                            .cornerRadius(self.showMenu ? 30 : 0)
                            // Shrinking And Moving View Right Side When Menu Button Is Clicked...
                            .scaleEffect(self.showMenu ? 0.9 : 1)
                            .offset(x: self.showMenu ? UIScreen.main.bounds.width / 2 : 0, y: self.showMenu ? 0 : 0)
                            // Rotating Slighlty...
                            .rotationEffect(.init(degrees: self.showMenu ? -5 : 0))
                            .environmentObject(mainViewModel)
                        
                        if showPage {
                            PageView(showPage: $showPage, page: page!)
                        }
                    }else{
                        NoNetworkView()
                    }
                }
                .background(Color.accentColor)
                .edgesIgnoringSafeArea(.all)
                .onAppear(){
                    EnvatoServiceAPI.shared.initialize(key: PURCHASE_CODE, completion: { (success) -> Void in
                        if success {
                            mainViewModel.fetchHeadlineData()
                            mainViewModel.fetchPosts()
                            mainViewModel.fetchCategories()
                            mainViewModel.fetchTags()
                            mainViewModel.fetchPages()
                        } else {
                            print("Your Purchase Code Wrong or Empty")
                        }
                    })
                    mainViewModel.isLoading = true
                }
            }
            
        }
    }
    
    
}

//*** Implement App delegate ***//
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        return true
    }
    //No callback in simulator
    //-- must use device to get valid push token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)          {
        Messaging.messaging().apnsToken = deviceToken
        updateFCMToken()
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    
    fileprivate func updateFCMToken() {
        Messaging.messaging().token { token, error in
            if let refreshedToken = token {
                let systemVersion = UIDevice.current.systemVersion
                
                //iPhone or iPad
                let model = UIDevice.current.model
                
                let deviceID = UIDevice.current.identifierForVendor!.uuidString
                print(deviceID)
                
                let parameters: [String: String] = [
                    "regid" : refreshedToken,
                    "device_name" : model,
                    "serial" : deviceID,
                    "os_version" : systemVersion
                ]
                
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json"
                ]
                
                AF.request("\(WORDPRESS_URL)/?api-fcm=register", method: .post,parameters:parameters, encoding: JSONEncoding.default, headers: headers).validate()
                    .responseJSON { response in
                               switch response.result {
                               case .success(let value):
                                   print(value)
                               case .failure(let error):
                                   print(error)
                               }
                       

                    }}
        }
        
        
    }
}


extension AppDelegate: MessagingDelegate {
    
    private func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        updateFCMToken()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        updateFCMToken()
    }
//    
//    // [START receive_message]
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//      // If you are receiving a notification message while your app is in the background,
//      // this callback will not be fired till the user taps on the notification launching the application.
//      // TODO: Handle data of notification
//      // With swizzling disabled you must let Messaging know about the message, for Analytics
//      // Messaging.messaging().appDidReceiveMessage(userInfo)
//      // Print message ID.
//      if let messageID = userInfo["gcm.message_id"] {
//        print("Message ID: \(messageID)")
//      }
//
//      // Print full message.
//      print(userInfo)
//
//      completionHandler(UIBackgroundFetchResult.newData)
//    }
//    // [END receive_message]
//    
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//
//        completionHandler([.badge, .sound])
//
//        let userInfo:NSDictionary = notification.request.content.userInfo as NSDictionary
//        print(userInfo)
//        let dict:NSDictionary = userInfo["aps"] as! NSDictionary
//        let data:NSDictionary = dict["alert"] as! NSDictionary
//        
//        print(dict)
////        UserDefaultsManager.saveNotification(AppNotification(title: (data["title"] as? String) ?? "", content: (data["body"] as? String) ?? ""))
//        
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo:NSDictionary = response.notification.request.content.userInfo as NSDictionary
//        print(userInfo)
//        let dict:NSDictionary = userInfo["aps"] as! NSDictionary
//        let data:NSDictionary = dict["alert"] as! NSDictionary
//        
//        print(dict)
//        
//        
////        UserDefaultsManager.saveNotification(AppNotification(title: (data["title"] as? String) ?? "", content: (data["body"] as? String) ?? ""))
//    }
}
