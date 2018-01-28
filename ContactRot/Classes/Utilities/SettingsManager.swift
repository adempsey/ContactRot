//
//  SettingsManager.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 11/30/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import Foundation

class SettingsManager: NSObject {

    // MARK: Public Properties

    public static let sharedInstance: SettingsManager = SettingsManager()

    // MARK: Private Properties

    private enum SettingsKeys: String {
        case DarkModeEnabled = "cr_setting_dark_mode_enabled"
        case HardModeEnabled = "cr_setting_hard_mode_enabled"
    }

    private var userDefaults: UserDefaults {
        get {
            return .standard
        }
    }

    // MARK: Settings

    public var darkModeEnabled: Bool {
        get {
            return self.userDefaults.bool(forKey: SettingsKeys.DarkModeEnabled.rawValue)
        }

        set(newValue) {
            self.userDefaults.set(newValue, forKey: SettingsKeys.DarkModeEnabled.rawValue)
        }
    }

    public var hardModeEnabled: Bool {
        get {
            return self.userDefaults.bool(forKey: SettingsKeys.HardModeEnabled.rawValue)
        }

        set(newValue) {
            self.userDefaults.set(newValue, forKey: SettingsKeys.HardModeEnabled.rawValue)
        }
    }

}
