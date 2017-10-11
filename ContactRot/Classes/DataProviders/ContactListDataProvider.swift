//
//  ContactListDataProvider.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/5/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import Contacts

class ContactListDataProvider: NSObject {

    private let dataManager: ContactDataManager? = ContactDataManager()

    private let keysToFetch: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor,
                                                  CNContactFamilyNameKey as CNKeyDescriptor]

    private var contacts: [Contact] = Array()

    public var count: Int {
        return self.contacts.count
    }

    public func retrieve() {

        guard let existingContacts = try? self.dataManager?.existingIDs() else {
            return
        }

        let req = CNContactFetchRequest(keysToFetch: self.keysToFetch)
        try! CNContactStore().enumerateContacts(with: req) {
            contactData, stop in
            let contactID = contactData.identifier
            let contactDate = existingContacts![contactID] ?? Date()
            let contact = Contact(data: contactData, contactDate: contactDate)
            self.contacts.append(contact)
        }

        try! self.dataManager?.saveNew(contacts: self.contacts)
    }

    public subscript(row: Int) -> Contact {
        get {
            return self.contacts[row]
        }
    }

}
