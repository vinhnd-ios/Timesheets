//
//  TimesheetItem.swift
//  Timesheets
//
//  Created by VINHND on 1/7/19.
//  Copyright © 2019 VINHND. All rights reserved.
//

import UIKit

enum ReasonType: String {
    case attendance = "ATTENDANCE_REQUEST_REASON"
}

class TimeSheetItem: NSObject {
    var breakTime: String?
    var checkInTime: String?
    var checkOutTime: String?
    var checkingLogLastEditedAt: String?
    var checkingLogLastEditedBy: String?
    var date: String?
    var extendedTime: String?
    var holidayWorkTime: String?
    var inHospitalTime: String?
    var nightWorkTime: String?
    var otherTime: String?
    var overTime: String?
    var overtimeInWeek: String?
    var shiftList: [ShiftItem]?
    var reasonType: ReasonType?
    var reasonName: String?
    
    init(dict: [String: Any]) {
        self.breakTime = dict["breakTime"] as? String
        self.checkInTime = dict["checkInTime"] as? String
        self.checkOutTime = dict["checkOutTime"] as? String
        self.checkingLogLastEditedAt = dict["checkingLogLastEditedAt"] as? String
        self.checkingLogLastEditedBy = dict["checkingLogLastEditedBy"] as? String
        self.date = dict["date"] as? String
        self.extendedTime = dict["extendedTime"] as? String
        self.holidayWorkTime = dict["holdayWorkTime"] as? String
        self.inHospitalTime = dict["inHospitalTime"] as? String
        self.nightWorkTime = dict["nightWorkTime"] as? String
        self.otherTime = dict["otherTime"] as? String
        self.overTime = dict["overTime"] as? String
        self.overtimeInWeek = dict["overtimeInWeek"] as? String
        if let shiftListDicts = dict["shiftList"] as? [[String: Any]] {
            self.shiftList = shiftListDicts.map { return ShiftItem(dict: $0) }
        }
        if let reasonType = dict["reasonType"] as? String {
            self.reasonType = ReasonType(rawValue: reasonType)
        }
        self.reasonName = dict["reasonName"] as? String
    }
}

class TimeSheet: NSObject {
    var officeUserId: String?
    var sumOfTimeInCell: SumOfTime?
    var timeSheetItemList: [TimeSheetItem]?
    var workingHoursInMonth: WorkingHoursInMonth?
    
    init(dict: [String: Any]) {
        self.officeUserId = dict["officeUserId"] as? String
        if let sumOfTimeDict = dict["sumOfTimeInCell"] as? [String: Any] {
            self.sumOfTimeInCell = SumOfTime(dict: sumOfTimeDict)
        }
        if let timeSheetItemDicts = dict["timeSheetItemList"] as? [[String: Any]] {
            self.timeSheetItemList = timeSheetItemDicts.map({ return TimeSheetItem(dict: $0) })
        }
        if let workingHoursInMonthDict = dict["workingHoursInMonth"] as? [String: Any] {
            self.workingHoursInMonth = WorkingHoursInMonth(dict: workingHoursInMonthDict)
        }
    }
}

//{
//    "officeUserId": "string",
//    "sumOfTimeInCell": {
//        "columnBreakTime": "string",
//        "columnExtendedTime": "string",
//        "columnInHospitalTime": "string",
//        "columnNightWorkTime": "string",
//        "columnOtherTime": "string",
//        "columnOvertime": "string"
//    },
//    "timeSheetItemList": [{
//        "breakTime": "string",
//        "checkInTime": "string",
//        "checkOutTime": "string",
//        "checkingLogLastEditedAt": "string",
//        "checkingLogLastEditedBy": "string",
//        "date": "string",
//        "extendedTime": "string",
//        "holdayWorkTime": "string",
//        "inHospitalTime": "string",
//        "nightWorkTime": "string",
//        "otherTime": "string",
//        "overTime": "string",
//        "overtimeInWeek": "string",
//        "shiftList": [{
//            "deptId": "string",
//            "guestShiftItem": "string",
//            "endTime": "string",
//            "periodTime": "PS_MORNING",
//            "shiftCategory": "SIC_IN_HOSPITAL_WORK",
//            "shiftItem": "string",
//            "startTime": "string"
//        }],
//        "reasonType": "ATTENDANCE_REQUEST_REASON",
//        "reasonName": "string"
//    }],
//    "workingHoursInMonth": {
//        "totalExtendedTime": "string",
//        "totalHolidayWorkingTime": "string",
//        "totalInHospitalTime": "string",
//        "totalNightWorkTime": "string",
//        "totalOvertimeInWeek": "string"
//    }
//}
