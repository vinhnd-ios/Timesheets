//
//  ShiftItem.swift
//  Timesheets
//
//  Created by VINHND on 1/7/19.
//  Copyright © 2019 VINHND. All rights reserved.
//

import UIKit

enum PeriodTime: String {
    case morning = "PS_MORNING"
}

enum ShiftCategory: String {
    case inHospitalWork = "SIC_IN_HOSPITAL_WORK"
}

class ShiftItem: NSObject {
    var deptId: String?
    var guestShiftItem: String?
    var endTime: String?
    var periodTime: PeriodTime?
    var shiftCategory: ShiftCategory?
    var shiftItem: String?
    var startTime: String?
    
    init(dict: [String: Any]) {
        self.deptId = dict["deptId"] as? String
        self.guestShiftItem = dict["guestShiftItem"] as? String
        self.endTime = dict["endTime"] as? String
        if let periodTime = dict["periodTime"] as? String {
            self.periodTime = PeriodTime(rawValue: periodTime)
        }
        if let shiftCategory = dict["shiftCategory"] as? String {
            self.shiftCategory = ShiftCategory(rawValue: shiftCategory)
        }
        self.shiftItem = dict["shiftItem"] as? String
        self.startTime = dict["startTime"] as? String
    }
}
