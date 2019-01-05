//
//  ViewController.swift
//  Timesheets
//
//  Created by VINHND on 1/5/19.
//  Copyright © 2019 VINHND. All rights reserved.
//

import UIKit
import SpreadsheetView

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

class ViewController: UIViewController {
    // MARK: - UI Property
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    @IBOutlet weak var sumScheduleCollectionView: UICollectionView!
    @IBOutlet weak var headerContainerView: UIView!

    lazy var headerView: TimesheetsHeaderView = { [weak self] in
        let view = TimesheetsHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    // MARK: - Property
    var timesheetInfors: [String] = [TimesheetInfo.firstCheckIn,
                                     TimesheetInfo.lastCheckOut,
                                     TimesheetInfo.hospitalStayTime,
                                     TimesheetInfo.extendedTime,
                                     TimesheetInfo.overtime,
                                     TimesheetInfo.otherTime,
                                     TimesheetInfo.breaktime,
                                     TimesheetInfo.nightWorkTime]
    
    var days: [Int] = []
    
    var dayNames: [String] = []
    
    var months: [Int] = Array(1...12)
    
    var dayDictionaries: [String: String] = [DayInWeekEng.monday: DayInWeekJpn.monday,
                                             DayInWeekEng.tuesday: DayInWeekJpn.tuesday,
                                             DayInWeekEng.wednesday: DayInWeekJpn.wednesday,
                                             DayInWeekEng.thursday: DayInWeekJpn.thursday,
                                             DayInWeekEng.friday: DayInWeekJpn.friday,
                                             DayInWeekEng.saturday: DayInWeekJpn.saturday,
                                             DayInWeekEng.sunday: DayInWeekJpn.sunday]

    var currentYear: Int!
    var currentMonth: Int!
    var currentDay: Int!
    
    let colorSaturday = UIColor(rgb: 0x4991DC)
    let colorSunday = UIColor(rgb: 0xFF0000)
    
    let widthFirstColumn: CGFloat = 88
    let widthOtherColumn: CGFloat = 78
    
    let heightFirstRow: CGFloat = 29
    let heightLastRow: CGFloat = 28
    let heightOtherRow: CGFloat = 48
    
    var currentDate = Date()
    let monthOffset = 1
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.initViews()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        spreadsheetView.flashScrollIndicators()
        sumScheduleCollectionView.flashScrollIndicators()
    }
    
    // MARK: - Config
    func initViews() {
        setupSpreadsheetView()
        updateCurrentDay()
        setupCollectionView()
        setupHeaderView()
    }

    func setupSpreadsheetView() {
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        
        spreadsheetView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        spreadsheetView.showsHorizontalScrollIndicator = false
        spreadsheetView.intercellSpacing = CGSize(width: 0, height: 0)
        spreadsheetView.gridStyle = .solid(width: 0.5, color: .lightGray)
        
        spreadsheetView.bounces = false
        spreadsheetView.scrollView.delegate = self
        
        spreadsheetView.register(TimesheetInforCell.self, forCellWithReuseIdentifier: String(describing: TimesheetInforCell.self))
        spreadsheetView.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
        spreadsheetView.register(DayCell.self, forCellWithReuseIdentifier: String(describing: DayCell.self))
        spreadsheetView.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
    }
    
    func setupCollectionView() {
        sumScheduleCollectionView.delegate = self
        sumScheduleCollectionView.dataSource = self
        sumScheduleCollectionView.bounces = false
        
        sumScheduleCollectionView.register(UINib.init(nibName: SumScheduleCell.identifier, bundle: nil), forCellWithReuseIdentifier: SumScheduleCell.identifier)
    }
    
    func setupHeaderView() {
        headerContainerView.addSubview(headerView)
        
        headerView.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor).isActive = true
        headerView.centerYAnchor.constraint(equalTo: headerContainerView.centerYAnchor).isActive = true
        headerView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        headerView.updateTitleLbl(titleAttributeString())
    }
    
    // MARK: - Handler
    fileprivate func updateCurrentDay() {
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
            return "\(dayNumber)" + (self.dayDictionaries[dayName] ?? "")
        })
    }
    
    private func handleUpdateDate(isPast: Bool) {
//        let offset = isPast ? -monthOffset : monthOffset
//        if presenter.needConfirmChangeDate(dayOffset) {
//            confirmChangeDate(isPast: past, completed: {})
//        } else {
            changeDate(isPast: isPast)
//        }
        
        updateCurrentDay()
        DispatchQueue.main.async {
            self.spreadsheetView.reloadData()
        }
    }
    
    private func changeDate(isPast: Bool, to date: Date? = nil) {
        if let date = date {
            self.currentDate = date
        } else {
            self.currentDate.add(.month, value: isPast ? -monthOffset : monthOffset)
        }
        
        headerView.updateTitleLbl(titleAttributeString())
    }
    
    func titleAttributeString(previous: Bool) -> NSAttributedString {
        currentDate.add(.day, value: previous ? -monthOffset : monthOffset)
        return titleAttributeString()
    }
    
    let INSIDE_YEAR_FORMAT = "yyyy年MM月"
    
    func titleAttributeString() -> NSAttributedString {
        let dateString = stringFromDate(currentDate, format: INSIDE_YEAR_FORMAT)
        
        let attributeString = NSAttributedString(string: dateString,
                                                 attributes: [.font: UIFont.boldSystemFont(ofSize: 19),
                                                              .foregroundColor: UIColor(rgb: 0x3B3732)])
        return attributeString
    }
    
    // MARK: - Notifications
    
    // MARK: - Override functions
    
    // MARK: - Utils
    func getDayNameFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dayInWeek = formatter.string(from: date)
        
        return dayInWeek
    }
    
    func getDayCountInMonth(year: Int, month: Int) -> Range<Int>? {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return nil
        }
        return range
    }
    
    func stringFromDate(_ date: Date, format: String) -> String {
        let formatter = formatterForFormat(format: format)
        return formatter.string(from: date)
    }
    
    func formatterForFormat(format: String) -> DateFormatter {
        var formatter: DateFormatter
        formatter = DateFormatter()
        formatter.dateFormat = format
        if let identify = Locale.preferredLanguages.first {
            formatter.locale = Locale(identifier: identify)
        }
        return formatter
    }

}

// MARK: - SpreadsheetViewDataSource
extension ViewController: SpreadsheetViewDataSource {
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return timesheetInfors.count + 1
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return dayNames.count + 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if case 0 = column {
            return widthFirstColumn
        } else {
            return widthOtherColumn
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return heightFirstRow
        } else {
            return heightOtherRow
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
        
        if case (1...timesheetInfors.count, 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimesheetInforCell.self), for: indexPath) as! TimesheetInforCell
            cell.label.text = timesheetInfors[indexPath.column - 1]
            cell.gridlines.left = .none
            if indexPath.column != timesheetInfors.count + 1 {
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
                cell.label.textColor = UIColor(rgb: 0x4991DC)
            } else if dayInWeek.contains(DayInWeekJpn.sunday) {
                cell.label.textColor = UIColor(rgb: 0xFF0000)
            } else {
                cell.label.textColor = UIColor(rgb: 0x3B3732)
            }
            
            return cell
        }
            
        if case (1...timesheetInfors.count, 1...dayNames.count) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            if indexPath.column != timesheetInfors.count {
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
extension ViewController: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }
}

// MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == spreadsheetView.scrollView {
            sumScheduleCollectionView.contentOffset.x = spreadsheetView.contentOffset.x
        } else if scrollView == sumScheduleCollectionView {
            spreadsheetView.contentOffset.x = sumScheduleCollectionView.contentOffset.x
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timesheetInfors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SumScheduleCell.identifier, for: indexPath) as! SumScheduleCell
        cell.sumLabel.text = "54:26"
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthOtherColumn, height: heightLastRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - TimesheetsHeaderView
extension ViewController: TimesheetsHeaderViewDelegate {
    func timesheetsHeaderViewDidChangeDateToPast(_ timesheetsHeaderView: TimesheetsHeaderView) {
        handleUpdateDate(isPast: true)
    }
    
    func timesheetsHeaderViewDidChangeDateToFutute(_ timesheetsHeaderView: TimesheetsHeaderView) {
        handleUpdateDate(isPast: false)
    }
    
    func timesheetsHeaderViewDidTapTitle(_ timesheetsHeaderView: TimesheetsHeaderView) {
        
    }
}

