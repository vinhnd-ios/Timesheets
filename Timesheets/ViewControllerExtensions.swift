//
//  ViewControllerExtensions.swift
//  Timesheets
//
//  Created by VINHND on 1/7/19.
//  Copyright © 2019 VINHND. All rights reserved.
//

import UIKit

struct DayInWeekEng {
    static let monday = "Monday"
    static let tuesday = "Tuesday"
    static let wednesday = "Wednesday"
    static let thursday = "Thursday"
    static let friday = "Friday"
    static let saturday = "Saturday"
    static let sunday = "Sunday"
}

struct DayInWeekJpn {
    static let monday = "日 月"
    static let tuesday = "日 火"
    static let wednesday = "日 水"
    static let thursday = "日 木"
    static let friday = "日 金"
    static let saturday = "日 土"
    static let sunday = "日 日"
}

struct TimesheetInfo {
    static let firstCheckIn = "出勤"
    static let lastCheckOut = "退勤"
    static let hospitalStayTime = "滞在"
    static let extendedTime = "超過"
    static let overtime = "残業"
    static let otherTime = "その他"
    static let breaktime = "休憩"
    static let nightWorkTime = "深夜"
}
