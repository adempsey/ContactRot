//
//  SettingsDataManager.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/13/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import Foundation

class SettingsDataManager: NSObject {

    // MARK: - Private Properties

    private enum Settings: String {
        case HasRequestedContactsPermission = "has_requested_contacts_permission"
        case HasAuthorizedContactsAccess = "has_authorized_contacts_access"
    }

    private let defaults = UserDefaults.standard

    // MARK: - Public Properties

    public var hasRequestedContactsPermission: Bool {

        get {
            return self.defaults.bool(forKey: Settings.HasRequestedContactsPermission.rawValue)
        }

        set(newValue) {
            self.defaults.set(newValue, forKey: Settings.HasRequestedContactsPermission.rawValue)
        }
    }

    public var hasAuthorizedContactsAccess: Bool {

        get {
            return self.defaults.bool(forKey: Settings.HasAuthorizedContactsAccess.rawValue)
        }

        set(newValue) {
            self.defaults.set(newValue, forKey: Settings.HasAuthorizedContactsAccess.rawValue)
        }
    }

    // MARK: - Initialization

    override init() {
        let defaults = [Settings.HasRequestedContactsPermission.rawValue: false,
                        Settings.HasAuthorizedContactsAccess.rawValue: false,]
        self.defaults.register(defaults: defaults)
    }

}
