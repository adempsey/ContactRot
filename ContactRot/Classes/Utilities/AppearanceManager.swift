//
//  AppearanceManager.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 11/30/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit

class AppearanceManager: NSObject {

    // MARK: Public Properties

    public static let sharedInstance: AppearanceManager = AppearanceManager()

    // MARK: Public Methods

    public func resetAppearances() {

        UIApplication.shared.statusBarStyle = UIColor.contactRotStatusBarStyle()

        UILabel.appearance().textColor = UIColor.contactRotTextColor()

        UITableView.appearance().backgroundColor = UIColor.contactRotBackgroundColor()

        UITextView.appearance().textColor = UIColor.contactRotTextColor()
        UITextView.appearance().tintColor = UIColor.contactRotBlue()

        UINavigationBar.appearance().barTintColor = UIColor.contactRotNeutral()
        UINavigationBar.appearance().tintColor = UIColor.contactRotTextColor()
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.contactRotTextColor()
        ]
    }
}
