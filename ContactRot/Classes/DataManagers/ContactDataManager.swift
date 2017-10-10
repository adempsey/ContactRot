//
//  ContactDataManager.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/9/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import Foundation

class ContactDataManager {

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

            guard let jsonDict = try? JSONSerialization.data(withJSONObject: []) else {
                return nil
            }

            self.fileManager.createFile(atPath: filePath,
                                        contents: jsonDict,
                                        attributes: nil)
        }
    }

}
