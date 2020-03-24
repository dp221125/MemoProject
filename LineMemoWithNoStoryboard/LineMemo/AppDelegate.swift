//
//  AppDelegate.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        UserDataManager.shared.loadMemoDataList()

        let mainMemoViewController = MainMemoViewController()
        let mainNavigationController = MainNavigationController(rootViewController: mainMemoViewController)

        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }

        self.window?.rootViewController = mainNavigationController
        self.window?.makeKeyAndVisible()
        return true
    }

    /*
     // MARK: UISceneSession Lifecycle

     func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         // Called when a new scene session is being created.
         // Use this method to select a configuration to create the new scene with.
         return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
     }

     func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         // Called when the user discards a scene session.
         // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
         // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
     }
     */
}
