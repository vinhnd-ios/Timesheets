//
//  ViewController.swift
//  Timesheets
//
//  Created by VINHND on 1/5/19.
//  Copyright © 2019 VINHND. All rights reserved.
//

import UIKit
import SpreadsheetView

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
    let monthOffset = 1
    
    var sumScheduleDatasource: SumScheduleDatasource!
    var timesheetsDatasource: TimesheetsDatasource!
    
    var timeSheet: TimeSheet?
    
    static let INSIDE_YEAR_FORMAT = "yyyy年MM月"

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
        setupDatasources()
        setupSpreadsheetView()
        setupCollectionView()
        setupHeaderView()
    }

    func setupSpreadsheetView() {
        spreadsheetView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        spreadsheetView.showsHorizontalScrollIndicator = false
        spreadsheetView.intercellSpacing = CGSize(width: 0, height: 0.5)
        spreadsheetView.gridStyle = .solid(width: 0.5, color: .lightGray)
        
        spreadsheetView.bounces = false
        
        spreadsheetView.register(TimesheetInforCell.self, forCellWithReuseIdentifier: String(describing: TimesheetInforCell.self))
        spreadsheetView.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
        spreadsheetView.register(DayCell.self, forCellWithReuseIdentifier: String(describing: DayCell.self))
        spreadsheetView.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
    }
    
    func setupCollectionView() {
        sumScheduleCollectionView.bounces = false
        sumScheduleCollectionView.register(UINib.init(nibName: SumScheduleCell.identifier, bundle: nil), forCellWithReuseIdentifier: SumScheduleCell.identifier)
    }
    
    func setupHeaderView() {
        headerContainerView.addSubview(headerView)
        
        headerView.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor).isActive = true
        headerView.centerYAnchor.constraint(equalTo: headerContainerView.centerYAnchor).isActive = true
        headerView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        headerView.updateTitleLbl(getTitleHeaderView())
    }
    
    func setupDatasources() {
        // Sum schedule collection view
        sumScheduleDatasource = SumScheduleDatasource.init(parentController: self, collectionView: sumScheduleCollectionView, timeSheet: timeSheet, width: TimesheetsDatasource.widthOtherColumn, height: TimesheetsDatasource.heightLastRow)
        self.sumScheduleCollectionView.dataSource = sumScheduleDatasource
        self.sumScheduleCollectionView.delegate = sumScheduleDatasource
        
        // Timesheets View
        timesheetsDatasource = TimesheetsDatasource(parentController: self, timesheetsView: spreadsheetView, timeSheet: timeSheet)
        timesheetsDatasource.updateCurrentDay()
        self.spreadsheetView.dataSource = timesheetsDatasource
        self.spreadsheetView.delegate = timesheetsDatasource
    }
    
    // MARK: - Handler
    private func handleUpdateDate(isPast: Bool) {
        changeDate(isPast: isPast)
        handleLoadTimeSheet()
    }
    
    private func changeDate(isPast: Bool, to date: Date? = nil) {
        if let date = date {
            self.timesheetsDatasource.currentDate = date
        } else {
            self.timesheetsDatasource.currentDate.add(.month, value: isPast ? -monthOffset : monthOffset)
        }
        timesheetsDatasource.updateCurrentDay()
        
        // Update title header
        let titleHeader = getTitleHeaderView()
        headerView.updateTitleLbl(titleHeader)
    }
    
    func getTitleHeaderView() -> NSAttributedString {
        let dateString = stringFromDate(self.timesheetsDatasource.currentDate, format: ViewController.INSIDE_YEAR_FORMAT)
        
        let attributeString = NSAttributedString(string: dateString,
                                                 attributes: [.font: UIFont.boldSystemFont(ofSize: 19),
                                                              .foregroundColor: UIColor(rgb: 0x3B3732)])
        return attributeString
    }
    
    /// Get time sheet data
    func handleLoadTimeSheet() {
        timeSheet = TimeSheet(dict: [:])
        
        self.reloadData()
    }
    
    /// Reload data schedule and sum schedule time
    func reloadData() {
        self.timesheetsDatasource.timeSheet = self.timeSheet
        self.sumScheduleDatasource.timeSheet = self.timeSheet
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.sumScheduleCollectionView.reloadData()
            self.spreadsheetView.reloadData()
        }
    }
    
    // MARK: - Notifications
    
    // MARK: - Override functions
    
    // MARK: - Utils
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

