//
//  Date+ContactRotAdditions.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/11/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import Foundation

extension Date {

    enum DateInterval: TimeInterval {
        case Day = 86400
        case Week = 604800
        case Month = 2678400
        case HalfYear = 16070400
    }

    func relativeFormat() -> String {
        let deltaInterval = self.timeIntervalSinceNow

        if deltaInterval < Date.DateInterval.Day.rawValue {
            return NSLocalizedString("today",
                                     comment: """
                                                 Indicates that the time that someone was last
                                                 contacted was within the past 24 hours
                                              """)
        } else if deltaInterval < Date.DateInterval.Week.rawValue {
            return NSLocalizedString("within the past week",
                                     comment: """
                                                 Indicates that the time that someone was last
                                                 contacted was within the past week
                                              """)
        } else if deltaInterval < Date.DateInterval.Month.rawValue {
            return NSLocalizedString("within the past month",
                                     comment: """
                                                 Indicates that the time that someone was last
                                                 contacted was within the past month
                                              """)
        } else if deltaInterval < Date.DateInterval.HalfYear.rawValue {
            return NSLocalizedString("within the past 6 months",
                                     comment: """
                                                 Indicates that the time that someone was last
                                                 contacted was within the past 6 months
                                              """)
        } else {
            return NSLocalizedString("over 6 months ago",
                                     comment: """
                                                 Indicates that the time that someone was last
                                                 contacted was over 6 months ago.
                                              """)
        }
    }

}
