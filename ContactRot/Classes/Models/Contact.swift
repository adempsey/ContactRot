//
//  Contact.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/9/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import Contacts

class Contact: Codable {

    public static let supportedKeys: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor,
                                                          CNContactFamilyNameKey as CNKeyDescriptor,
                                                          CNContactPhoneNumbersKey as CNKeyDescriptor,
                                                          CNContactEmailAddressesKey as CNKeyDescriptor,
                                                          CNContactThumbnailImageDataKey as CNKeyDescriptor]

    let givenName: String
    let familyName: String
    let phoneNumbers: [String]
    let emailAddresses: [String]
    let contactID: String
    let thumbnailData: Data?
    var lastContactDate: Date
    var hasBeenContacted: Bool

    var fullNameWithEntropy: String {
        get {
            let fullName = String(format: "%@ %@", self.givenName, self.familyName)
            let interval = self.lastContactDate.timeIntervalSinceNow
            return fullName.stringWithEntropy(interval)
        }
    }

    init(data: CNContact, contactDate: Date) {
        self.givenName = data.givenName
        self.familyName = data.familyName
        self.phoneNumbers = data.phoneNumbers.map() { $0.value.stringValue}
        self.emailAddresses = data.emailAddresses.map() { $0.value as String }
        self.contactID = data.identifier
        self.lastContactDate = contactDate
        self.thumbnailData = data.thumbnailImageData
        self.hasBeenContacted = true
    }

    public func contactDateDescription() -> String {
        if !self.hasBeenContacted {
            return "Not yet contacted"
        }

        return String(format: "Last contacted %@", self.lastContactDate.relativeFormat())
    }

}
