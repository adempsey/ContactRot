//
//  Date+ContactRotAdditions.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/11/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import Foundation

extension Date {

    static var never: Date {
        return Date.distantFuture
    }

    enum DateInterval: TimeInterval {
        case Day = 86400
        case Week = 604800
        case Month = 2678400
        case HalfYear = 16070400
    }

    func relativeFormatDescription() -> String {

        if self == Date.never {
            return NSLocalizedString("New Contact",
                                     comment: """
                                                     Indicates that the user has not contacted this
                                                     contact through ContactRot yet
                                                  """)
        }

        let deltaInterval = abs(self.timeIntervalSinceNow)

        let relativeDate: String = {
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
        }()

        return String(format: "Last contacted %@", relativeDate)
    }

}
