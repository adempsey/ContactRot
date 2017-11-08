//
//  String+ContactRotAdditions.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 11/8/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import Foundation

extension String {

    public func stringWithEntropy(_ timeInterval: TimeInterval) -> String {

        if abs(timeInterval) > Date.DateInterval.Month.rawValue {
            var string: String = self.lowercased()

            let spaces = Int(ceil(abs(timeInterval) / Date.DateInterval.Month.rawValue))

            for _ in 0...spaces {
                let randomOffset = Int(arc4random_uniform(UInt32(string.count)))
                let index = string.index(string.startIndex, offsetBy: randomOffset)
                string.insert(" ", at: index)
            }

            return string
        }

        return self
    }

}
