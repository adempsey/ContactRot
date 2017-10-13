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
    let lastContactDate: Date
    let thumbnailData: Data?

    init(data: CNContact, contactDate: Date) {
        self.givenName = data.givenName
        self.familyName = data.familyName
        self.phoneNumbers = data.phoneNumbers.map() { $0.value.stringValue}
        self.emailAddresses = data.emailAddresses.map() { $0.value as String }
        self.contactID = data.identifier
        self.lastContactDate = contactDate
        self.thumbnailData = data.thumbnailImageData
    }

}
