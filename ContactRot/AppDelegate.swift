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
            let containerView = ContainerViewController()
            window.rootViewController = containerView
            window.makeKeyAndVisible()
        }

        self.setupAppearances()

        return true
    }

    private func setupAppearances() {

        UIApplication.shared.statusBarStyle = .lightContent

        UILabel.appearance().textColor = UIColor.contactRotTextColor()

        UITableView.appearance().backgroundColor = UIColor.contactRotBackgroundColor()

        UITextView.appearance().textColor = UIColor.contactRotTextColor()
        UITextView.appearance().tintColor = UIColor.contactRotBlue()

        UINavigationBar.appearance().barTintColor = UIColor.contactRotGray()
        UINavigationBar.appearance().tintColor = UIColor.contactRotTextColor()
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.contactRotTextColor()
        ]
    }

}

