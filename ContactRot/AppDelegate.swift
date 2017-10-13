//
//  AppDelegate.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/5/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    // MARK: - App Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])

        if let window = self.window {
            let contactList: ContactListViewController = ContactListViewController()
            let navigationController = UINavigationController(rootViewController: contactList)
            navigationController.navigationBar.tintColor = UIColor(white: 0.3, alpha: 1.0)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }

        return true
    }

}

