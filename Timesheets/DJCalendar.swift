//
//  DJCalendar.swift
//  Drjoy
//
//  Created by Tăng on 4/20/18.
//  Copyright © 2018 Dr.JOY No,054. All rights reserved.
//

import Foundation

public struct DJCalendar {
    private init() {}
    public static var current: Calendar {
        var calendar = Calendar.current
        if let identify = Locale.preferredLanguages.first {
            calendar.locale = Locale(identifier: identify)
        }
        return calendar
    }
    
    public static var gregorianCalendar: Calendar {
        var calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        if let identify = Locale.preferredLanguages.first {
            calendar.locale = Locale(identifier: identify)
        }
        return calendar
    }
}
