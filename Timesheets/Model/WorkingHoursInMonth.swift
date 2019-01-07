//
//  WorkingHoursInMonth.swift
//  Timesheets
//
//  Created by VINHND on 1/7/19.
//  Copyright © 2019 VINHND. All rights reserved.
//

import UIKit

class WorkingHoursInMonth: NSObject {
    var totalExtendedTime: String?
    var totalHolidayWorkingTime: String?
    var totalInHospitalTime: String?
    var totalNightWorkTime: String?
    var totalOvertimeInWeek: String?
    
    init(dict: [String: Any]) {
        self.totalExtendedTime = dict["totalExtendedTime"] as? String
        self.totalHolidayWorkingTime = dict["totalHolidayWorkingTime"] as? String
        self.totalInHospitalTime = dict["totalInHospitalTime"] as? String
        self.totalNightWorkTime = dict["totalNightWorkTime"] as? String
        self.totalOvertimeInWeek = dict["totalOvertimeInWeek"] as? String
    }
}
