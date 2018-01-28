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
        let deltaInterval = abs(self.timeIntervalSinceNow)

        if NSCalendar.current.isDateInToday(self) {
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
        } else if deltaInterval < Date.DateInterval.Week.rawValue * 2 {
            return NSLocalizedString("within the past two weeks",
                                     comment: """
                                                 Indicates that the time that someone was last
                                                 contacted was within the past two weeks
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

    static func maxTimeFromLastContact() -> TimeInterval {
        return SettingsManager.sharedInstance.hardModeEnabled ?
            Date.DateInterval.Week.rawValue * 2 :
            Date.DateInterval.HalfYear.rawValue
    }

}
