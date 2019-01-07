//
//  SumOfTime.swift
//  Timesheets
//
//  Created by VINHND on 1/7/19.
//  Copyright © 2019 VINHND. All rights reserved.
//

import UIKit

class SumOfTime: NSObject {
    var columnBreakTime: String?
    var columnExtendedTime: String?
    var columnInHospitalTime: String?
    var columnNightWorkTime: String?
    var columnOtherTime: String?
    var columnOvertime: String?
    
    init(dict: [String: Any]) {
        self.columnBreakTime = dict["columnBreakTime"] as? String
        self.columnExtendedTime = dict["columnExtendedTime"] as? String
        self.columnInHospitalTime = dict["columnInHospitalTime"] as? String
        self.columnNightWorkTime = dict["columnNightWorkTime"] as? String
        self.columnOtherTime = dict["columnOtherTime"] as? String
        self.columnOvertime = dict["columnOvertime"] as? String
    }
}
