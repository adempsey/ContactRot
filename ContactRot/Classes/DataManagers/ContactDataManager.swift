//
//  ContactDataManager.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/9/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import Foundation

class ContactDataManager {

    public static let sharedInstance: ContactDataManager = ContactDataManager()

    enum ContactsFileError: Error {
        case ContactsFilePathUndefined
        case ContactsFileNotFound
    }

    private enum ContactsFileKeys: String, Codable {
        case LastContactDate = "last_contact_date"
        case HasBeenContacted = "has_been_contacted"
    }

    private let fileName = "contact_list.json"

    private let fileManager = FileManager.default

    private lazy var filePath: String? = {
        let searchPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                             .userDomainMask,
                                                             true).first
        if let searchPath = searchPath, let searchPathURL = URL(string: searchPath) {
            return searchPathURL.appendingPathComponent(self.fileName).path
        }

        return nil
    }()

    // MARK: Public Methods

    public func existingIDs() throws -> [String:Date] {
        do {
            let savedContacts = try self.currentFileContents()

            return savedContacts.mapValues() {
                value in
                let date = Double(value[ContactsFileKeys.LastContactDate]!)!
                return Date(timeIntervalSince1970: Double(date))
            }

        } catch let error {
            throw error
        }
    }

    public func newContacts() throws -> Set<String> {
        do {
            let savedContacts = try self.currentFileContents()
            let newContacts = savedContacts.filter {
                Bool($0.value[ContactsFileKeys.HasBeenContacted]!)! == false
            }

            return Set(newContacts.map { $0.key })

        } catch let error {
            throw error
        }
    }

    public func saveNew(contacts: [Contact]) throws {
        do {
            var savedContacts = try self.currentFileContents()

            let currentKeys = Set(savedContacts.keys)
            let newContacts = contacts.filter { !currentKeys.contains($0.contactID) }

            savedContacts = newContacts.reduce(savedContacts) {
                (dict, contact) in
                var d = dict
                d[contact.contactID] = [
                    ContactsFileKeys.LastContactDate: String(contact.lastContactDate.timeIntervalSince1970),
                    ContactsFileKeys.HasBeenContacted: String(false),
                ]
                return d
            }

            try self.replaceFile(with: savedContacts)

        } catch let error {
            throw error
        }
    }

    public func updateContactDate(for contacts: [Contact]) throws {
        do {
            var savedContacts = try self.currentFileContents()

            for contact: Contact in contacts {
                savedContacts[contact.contactID] = [
                    ContactsFileKeys.LastContactDate: String(Date().timeIntervalSince1970),
                    ContactsFileKeys.HasBeenContacted: String(true),
                ]
            }

            try self.replaceFile(with: savedContacts)

        } catch let error {
            throw error
        }
    }

    // MARK: - Helper Methods

    private func currentFileContents() throws -> [String:[ContactsFileKeys:String]] {
        do {
            let filePathURL = try self.currentFilePath()
            let fileContents = try Data(contentsOf: filePathURL)

            return try JSONDecoder().decode(Dictionary<String,[ContactsFileKeys:String]>.self,
                                            from: fileContents)
        } catch let error {
            throw error
        }
    }

    private func replaceFile(with contents: [String:[ContactsFileKeys:String]]) throws {

        do {
            let filePathURL = try self.currentFilePath()
            let newData = try JSONEncoder().encode(contents)
            try newData.write(to: filePathURL, options: .atomicWrite)

        } catch let error {
            throw error
        }
    }

    private func currentFilePath() throws -> URL {
        guard let filePath = self.filePath else {
            throw ContactsFileError.ContactsFilePathUndefined
        }

        if !self.fileManager.fileExists(atPath: filePath) {
            do {
                let jsonDict = try JSONEncoder().encode([String:String]())
                self.fileManager.createFile(atPath: filePath,
                                            contents: jsonDict,
                                            attributes: nil)
            } catch let error {
                throw error
            }
        }

        return URL(fileURLWithPath: filePath)
    }

}
