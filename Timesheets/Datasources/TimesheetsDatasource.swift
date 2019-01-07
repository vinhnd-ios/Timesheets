//
//  TimesheetsViewDatasource.swift
//  Timesheets
//
//  Created by VINHND on 1/7/19.
//  Copyright © 2019 VINHND. All rights reserved.
//

import UIKit
import SpreadsheetView

class TimesheetsDatasource: NSObject {
    var width: CGFloat?
    var height: CGFloat?
    
    var schedules: [[CGFloat]] = []
    
    var numberOfItems: Int?
    
    weak var parentController: ViewController?
    
    weak var timesheetsView: SpreadsheetView?
    
    static let timesheetInfors: [String] = [TimesheetInfo.firstCheckIn,
                                     TimesheetInfo.lastCheckOut,
                                     TimesheetInfo.hospitalStayTime,
                                     TimesheetInfo.extendedTime,
                                     TimesheetInfo.overtime,
                                     TimesheetInfo.otherTime,
                                     TimesheetInfo.breaktime,
                                     TimesheetInfo.nightWorkTime]
    
    static let dayDictionaries: [String: String] = [DayInWeekEng.monday: DayInWeekJpn.monday,
                                             DayInWeekEng.tuesday: DayInWeekJpn.tuesday,
                                             DayInWeekEng.wednesday: DayInWeekJpn.wednesday,
                                             DayInWeekEng.thursday: DayInWeekJpn.thursday,
                                             DayInWeekEng.friday: DayInWeekJpn.friday,
                                             DayInWeekEng.saturday: DayInWeekJpn.saturday,
                                             DayInWeekEng.sunday: DayInWeekJpn.sunday]
    
    var days: [Int] = []
    
    var dayNames: [String] = []
    
    var months: [Int] = Array(1...12)
    
    var currentYear: Int!
    var currentMonth: Int!
    var currentDay: Int!
    
    static let colorSaturday = UIColor(rgb: 0x4991DC)
    static let colorSunday = UIColor(rgb: 0xFF0000)
    static let colorDayNormal = UIColor(rgb: 0x3B3732)
    
    static let widthFirstColumn: CGFloat = 88
    static let widthOtherColumn: CGFloat = 78
    
    static let heightFirstRow: CGFloat = 29
    static let heightLastRow: CGFloat = 28
    static let heightOtherRow: CGFloat = 48
    
    var currentDate = Date()
    
    init(parentController: ViewController, timesheetsView: SpreadsheetView, schedules: [[CGFloat]]) {
        super.init()
        
        self.parentController = parentController
        self.timesheetsView = timesheetsView
        self.timesheetsView?.scrollView.delegate = self
        self.schedules = schedules
    }
    
    // MARK: - UI Property
    
    // MARK: - Property
    
    // MARK: - Life Cycle
    
    // MARK: - Config
    
    // MARK: - Handler
    func updateCurrentDay() {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        self.currentYear =  components.year
        self.currentMonth = components.month
        self.currentDay = components.day
        
        updateListDay()
    }
    
    fileprivate func updateListDay() {
        guard let currentYear = self.currentYear, let currentMonth = self.currentMonth else {
            return
        }
        guard let rangeDayInMonth = getDayCountInMonth(year: currentYear, month: currentMonth) else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.days = Array(rangeDayInMonth.lowerBound..<rangeDayInMonth.upperBound)
        self.dayNames = self.days.map({ (dayNumber) -> String in
            let dateString = "\(currentYear)-\(currentMonth)-\(dayNumber)"
            
            guard let date = dateFormatter.date(from: dateString) else {
                return ""
            }
            
            let dayName = getDayNameFromDate(date: date)
            return "\(dayNumber)" + (TimesheetsDatasource.dayDictionaries[dayName] ?? "")
        })
    }
    
    // MARK: - Notifications
    
    // MARK: - Ovveride functions
    
    // MARK: - Utils
    fileprivate func getDayNameFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayInWeek = formatter.string(from: date)
        
        return dayInWeek
    }
    
    fileprivate func getDayCountInMonth(year: Int, month: Int) -> Range<Int>? {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return nil
        }
        return range
    }
}

// MARK: - SpreadsheetViewDataSource
extension TimesheetsDatasource: SpreadsheetViewDataSource {
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return TimesheetsDatasource.timesheetInfors.count + 1
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return dayNames.count + 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if case 0 = column {
            return TimesheetsDatasource.widthFirstColumn
        } else {
            return TimesheetsDatasource.widthOtherColumn
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return TimesheetsDatasource.heightFirstRow
        } else {
            return TimesheetsDatasource.heightOtherRow
        }
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case (0, 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeTitleCell.self), for: indexPath) as! TimeTitleCell
            cell.label.text = ""
            cell.gridlines.right = .none
            return cell
        }
        
        if case (1...TimesheetsDatasource.timesheetInfors.count, 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimesheetInforCell.self), for: indexPath) as! TimesheetInforCell
            cell.label.text = TimesheetsDatasource.timesheetInfors[indexPath.column - 1]
            cell.gridlines.left = .none
            if indexPath.column != TimesheetsDatasource.timesheetInfors.count + 1 {
                cell.gridlines.right = .none
            }
            return cell
        }
        
        if case (0, 1...dayNames.count) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayCell.self), for: indexPath) as! DayCell
            cell.gridlines.top = .none
            cell.gridlines.bottom = .none
            
            let dayInWeek = dayNames[indexPath.row - 1]
            cell.label.text = dayInWeek
            
            if dayInWeek.contains(DayInWeekJpn.saturday) {
                cell.label.textColor = TimesheetsDatasource.colorSaturday
            } else if dayInWeek.contains(DayInWeekJpn.sunday) {
                cell.label.textColor = TimesheetsDatasource.colorSunday
            } else {
                cell.label.textColor = TimesheetsDatasource.colorDayNormal
            }
            
            return cell
        }
        
        if case (1...TimesheetsDatasource.timesheetInfors.count, 1...dayNames.count) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            if indexPath.column != TimesheetsDatasource.timesheetInfors.count {
                cell.gridlines.right = .none
            }
            if indexPath.column != 1 {
                cell.gridlines.left = .none
            }
            
            return cell
        }
        
        return nil
    }
}

// MARK: - SpreadsheetViewDelegate
extension TimesheetsDatasource: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }
}

// MARK: - UIScrollViewDelegate
extension TimesheetsDatasource: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let timesheetsView = self.timesheetsView else {
            return
        }
        self.parentController?.sumScheduleCollectionView.contentOffset.x = timesheetsView.contentOffset.x
    }
}
