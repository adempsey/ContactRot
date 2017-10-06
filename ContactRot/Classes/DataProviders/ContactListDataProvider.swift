//
//  ContactListDataProvider.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/5/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit
import Contacts

class ContactListDataProvider: NSObject {

    private let keysToFetch: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor,
                                                  CNContactFamilyNameKey as CNKeyDescriptor]

    private var contacts: [CNContact] = Array()

    public var count: Int {
        return self.contacts.count
    }

    public func retrieve() {
        let req = CNContactFetchRequest(keysToFetch: self.keysToFetch)
        try! CNContactStore().enumerateContacts(with: req) {
            contact, stop in
            self.contacts.append(contact)
        }
    }

    public subscript(row: Int) -> CNContact {
        get {
            return self.contacts[row]
        }
    }

}
