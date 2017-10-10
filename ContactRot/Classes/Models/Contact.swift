//
//  Contact.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/9/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import Contacts

class Contact: NSObject {

    let givenName: String
    let familyName: String
    let contactID: String
    let lastContactDate: Date

    init(data: CNContact) {
        self.givenName = data.givenName
        self.familyName = data.familyName
        self.contactID = data.identifier
        self.lastContactDate = Date()
    }

}
