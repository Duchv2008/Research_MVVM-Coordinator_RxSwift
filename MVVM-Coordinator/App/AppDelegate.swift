//
//  AppDelegate.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/16/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit
import RxSwift
import Firebase
import Messages
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    private var bag = DisposeBag()

    static var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }

    lazy var changeViewAnimation: CATransition = {
        let animation = CATransition()
        animation.duration = 0.3
        animation.type = CATransitionType.reveal
        animation.subtype = CATransitionSubtype.fromTop
        return animation
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: self.window!)
        appCoordinator.start()
            .subscribe()
            .disposed(by: bag)

        // Setup Firebase Service
        FirebaseApp.configure()
        // Remote config Firebase
        RemoteConfigFirebaseManager.shared.fetchRemoteConfig(completed: nil)


        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

// MARK: - Handle Push Notification
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    // MARK: - Config Push notification
    private func configApplePush(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Logger.log(msg: "didReceiveRemoteNotification: \(userInfo)")
        completionHandler(UIBackgroundFetchResult.newData)
    }

    /// Handle push when app in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Logger.log(msg: "willPresent: \(notification)")
        Logger.log(msg: "willPresent userinfo: \(notification.request.content.userInfo)")
        if let content = notification.request.content.userInfo as? [String: Any] {
            if let pushNotificationResponse = Mapper<PushNotificationResponse>().map(JSON: content) {
                Logger.log(msg: "willPresent PushNotificationResponse: \(pushNotificationResponse.toJSON())")
            }
        }
        completionHandler([.sound, .badge])
    }

    /// Handle user click to Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification
        Logger.log(msg: "didReceive: \(response)")
        Logger.log(msg: "didReceive userinfo: \(response.notification.request.content.userInfo)")
        defer {
            completionHandler()
        }

        if let content = notification.request.content.userInfo as? [String: Any] {
            if let pushNotificationResponse = Mapper<PushNotificationResponse>().map(JSON: content) {
                Logger.log(msg: "didReceive PushNotificationResponse: \(pushNotificationResponse.toJSON())")
//                self.delegatePushNotification?.handleUserAction(notification: pushNotificationResponse)
            }
        }
    }

    /// Handle Device Token
    /// Send API device Token to server
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        //        Messaging.messaging().apnsToken = deviceToken
        //        Logger.log(msg: "Device token: \(token)")
        //        PushNotificationUserDefault.shared.saveDeviceToken(deviceToken: token)
    }

    /// Handle Error get device Token
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        PushNotificationUserDefault.shared.removeDeviceToken()
        print("device token failed to register for remote notifications with with error: \(error)")
    }

    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Logger.log(msg: "Firebase registration token: \(fcmToken)")
//        PushNotificationUserDefault.shared.saveDeviceToken(deviceToken: fcmToken)
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

