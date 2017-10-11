//
//  ContactDataManager.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/9/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import Foundation

class ContactDataManager {

    enum ContactsFileError: Error {
        case ContactsFilePathUndefined
        case ContactsFileNotFound
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

    // MARK: - Initialization

    init?() {
        guard let filePath = self.filePath else {
            return nil
        }

        if !self.fileManager.fileExists(atPath: filePath) {

            guard let jsonDict = try? JSONEncoder().encode([String:String]()) else {
                return nil
            }

            self.fileManager.createFile(atPath: filePath,
                                        contents: jsonDict,
                                        attributes: nil)
        }
    }

    // MARK: Public Methods

    public func existingIDs() throws -> [String:Date] {
        do {
            let savedContacts = try self.currentFileContents()

            return savedContacts.mapValues() {
                value in
                return Date(timeIntervalSince1970: Double(value)!)
            }

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
                d[contact.contactID] = String(contact.lastContactDate.timeIntervalSince1970)
                return d
            }

            try self.replaceFile(with: savedContacts)

        } catch let error {
            throw error
        }
    }

    // MARK: - Helper Methods

    private func currentFileContents() throws -> [String:String] {
        do {
            guard let filePath = self.filePath else {
                throw ContactsFileError.ContactsFilePathUndefined
            }

            guard self.fileManager.fileExists(atPath: filePath) else {
                throw ContactsFileError.ContactsFilePathUndefined
            }

            let filePathURL = URL(fileURLWithPath: filePath)
            let fileContents = try Data(contentsOf: filePathURL)

            return try JSONDecoder().decode(Dictionary<String,String>.self,
                                            from: fileContents)
        } catch let error {
            throw error
        }
    }

    private func replaceFile(with contents: [String:String]) throws {
        guard let filePath = self.filePath else {
            throw ContactsFileError.ContactsFilePathUndefined
        }

        guard self.fileManager.fileExists(atPath: filePath) else {
            throw ContactsFileError.ContactsFilePathUndefined
        }

        let filePathURL = URL(fileURLWithPath: filePath)

        do {
            let newData = try JSONEncoder().encode(contents)
            try newData.write(to: filePathURL, options: .atomicWrite)
        } catch let error {
            throw error
        }
    }

}
