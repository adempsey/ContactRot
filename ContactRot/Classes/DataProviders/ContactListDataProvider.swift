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

    private var contacts: [Contact] = Array()

    public var count: Int {
        return self.contacts.count
    }

    public func retrieve() {
        let req = CNContactFetchRequest(keysToFetch: self.keysToFetch)
        try! CNContactStore().enumerateContacts(with: req) {
            contactData, stop in
            let contact = Contact(data: contactData)
            self.contacts.append(contact)
        }
    }

    public subscript(row: Int) -> Contact {
        get {
            return self.contacts[row]
        }
    }

}
