//
//  ContactListDataProvider.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/5/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import Contacts

class ContactListDataProvider: NSObject {

    private let dataManager: ContactDataManager = ContactDataManager.sharedInstance

    private var contacts: [Contact] = Array()

    public var count: Int {
        return self.contacts.count
    }

    public func retrieve() {

        guard let existingContacts = try? self.dataManager.existingIDs() else {
            return
        }

        let req = CNContactFetchRequest(keysToFetch: Contact.supportedKeys)
        try! CNContactStore().enumerateContacts(with: req) {
            contactData, stop in
            let contactID = contactData.identifier
            let contactDate = existingContacts[contactID] ?? Date()
            let contact = Contact(data: contactData, contactDate: contactDate)
            self.contacts.append(contact)
        }

        try! self.dataManager.saveNew(contacts: self.contacts)

        self.contacts = self.contacts.filter {
            $0.lastContactDate.timeIntervalSinceNow < Date.DateInterval.HalfYear.rawValue
        }

        self.contacts = try! self.contacts.sorted {
            (contactA, contactB) throws -> Bool in
            return contactA.givenName.lowercased() < contactB.givenName.lowercased()
        }
    }

    public subscript(row: Int) -> Contact {
        get {
            return self.contacts[row]
        }
    }

}
