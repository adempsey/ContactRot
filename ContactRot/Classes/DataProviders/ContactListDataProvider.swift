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

    private var contacts: [String: [Contact]] = Dictionary()

    public var count: Int {
        return self.contacts.count
    }

    public func retrieve() {

        guard let existingContacts = try? self.dataManager.existingIDs() else {
            return
        }

        var contacts: [Contact] = Array()

        let req = CNContactFetchRequest(keysToFetch: Contact.supportedKeys)
        try! CNContactStore().enumerateContacts(with: req) {
            contactData, stop in
            let contactID = contactData.identifier
            let contactDate = existingContacts[contactID] ?? Date()
            let contact = Contact(data: contactData, contactDate: contactDate)
            contacts.append(contact)
        }

        contacts = contacts.filter {
            $0.lastContactDate.timeIntervalSinceNow < Date.DateInterval.HalfYear.rawValue
        }

        self.contacts = contacts.reduce([String: [Contact]]()) {
            (accum, contact) in
            var dict = accum

            let key: String? = {
                if let firstChar = contact.givenName.first {
                    return String(describing: firstChar).lowercased()

                } else if let firstChar = contact.familyName.first {
                    return String(describing: firstChar).lowercased()
                }

                return nil
            }()

            if let key = key {
                if dict[key] == nil {
                    dict[key] = [contact]
                } else {
                    dict[key]!.append(contact)
                }
            }

            return dict
        }
    }

    public subscript(section: Int) -> [Contact]? {
        get {
            let key = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"][section]
            return self.contacts[key]
        }
    }

    public subscript(section: Int, row: Int) -> Contact? {
        get {
            let key = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"][section]
            return self.contacts[key]?[row]
        }
    }

}
