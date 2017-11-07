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

    public var sectionTitles: [String] {
        get {
            return ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
                    "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
                    "w", "x", "y", "z", "#"]
        }
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

        try! self.dataManager.saveNew(contacts: contacts)

        contacts = contacts.filter {
            $0.lastContactDate.timeIntervalSinceNow < Date.DateInterval.HalfYear.rawValue
        }

        self.contacts = contacts.reduce([String: [Contact]]()) {
            (accum, contact) in
            var dict = accum

            let key: String? = {
                if let firstChar = contact.givenName.first {
                    let character = String(describing: firstChar).lowercased()
                    if self.sectionTitles.contains(character) {
                        return character
                    } else {
                        return "#"
                    }

                } else if let firstChar = contact.familyName.first {
                    let character = String(describing: firstChar).lowercased()
                    if self.sectionTitles.contains(character) {
                        return character
                    } else {
                        return "#"
                    }
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

        self.contacts = self.contacts.mapValues {
            (value) in
            return value.sorted {
                (contactA, contactB) in
                let concatenatedNameA = contactA.givenName.appending(contactA.familyName)
                let concatenatedNameB = contactB.givenName.appending(contactB.familyName)

                return concatenatedNameA.lowercased() < concatenatedNameB.lowercased()
            }
        }
    }

    public subscript(section: Int) -> [Contact]? {
        get {
            let key = self.sectionTitles[section]
            return self.contacts[key]
        }
    }

    public subscript(section: Int, row: Int) -> Contact? {
        get {
            let key = self.sectionTitles[section]
            return self.contacts[key]?[row]
        }
    }

}
