//
//  AppDelegate.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/5/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    // MARK: - App Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if let window = self.window {
            let contactList: ContactListViewController = ContactListViewController()
            let navigationController = UINavigationController(rootViewController: contactList)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }

        return true
    }

}

