//
//  AppDelegate.swift
//  ymsports
//
//  Created by wood on 3/3/21.
//

import IQKeyboardManagerSwift
import UIKit
import YMSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var application: UIApplication!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.application = application
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        // 语言初始化
        Localized.initConfig()
        // 显示main window
        showMainWindow()
        // 注册通知
        registerNotification()
        // 键盘助手
        IQKeyboardManager.shared.enable = true

        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // reset badge number
        application.applicationIconBadgeNumber = 0
    }

    func showMainWindow() {
        let home = HomeViewController()
        home.tabBarItem = UITabBarItem(title: "com_tabBar_home".localized(), image: UIImage(named: "navigationbar_benefits"), tag: 0)
        let benefits = BenefitsViewController()
        benefits.tabBarItem = UITabBarItem(title: "com_tabBar_benefits".localized(), image: UIImage(named: "navigationbar_benefits"), tag: 1)
        let customer = BaseViewController()
        customer.tabBarItem = UITabBarItem(title: "com_tabBar_customer".localized(), image: UIImage(named: "navigationbar_customer"), tag: 2)
        let sponsor = SponsorViewController()
        sponsor.tabBarItem = UITabBarItem(title: "com_tabBar_sponsor".localized(), image: UIImage(named: "navigationbar_sponsor"), tag: 3)
        let mine = MineViewController()
        mine.tabBarItem = UITabBarItem(title: "com_tabBar_mine".localized(), image: UIImage(named: "navigationbar_user"), tag: 4)
        let tab = UITabBarController()
        tab.viewControllers = [home, benefits, customer, sponsor, mine].compactMap({ BaseNavController(rootViewController: $0) })
        window?.rootViewController = tab
    }

    private func registerNotification() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { flag, error in
            XLog([flag, error.debugDescription])
        })
        application.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        XLog("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        XLog("APNs token retrieved: \(deviceToken)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == .background {
            application.applicationIconBadgeNumber += 1
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 前台收到通知
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // TODO: 用户点击通知
//        if let userInfo = response.notification.request.content.userInfo as? [String: Any],
//           let message = userInfo["message"] as? String,
//           let dict = JSON(parseJSON: message).dictionaryObject {
//            XLog("didReceive: \(userInfo)")
    }
}
