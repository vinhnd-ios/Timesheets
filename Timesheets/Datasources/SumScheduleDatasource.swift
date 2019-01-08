//
//  SumScheduleDatasource.swift
//  Timesheets
//
//  Created by VINHND on 1/7/19.
//  Copyright © 2019 VINHND. All rights reserved.
//

import UIKit

class SumScheduleDatasource: NSObject {
    var width: CGFloat?
    var height: CGFloat?
    
    var timeSheet: TimeSheet?
    
    weak var parentController: ViewController?
    
    var collectionView: UICollectionView?
    
    init(parentController: ViewController, collectionView: UICollectionView, timeSheet: TimeSheet?, width: CGFloat, height: CGFloat) {
        super.init()
        
        self.parentController = parentController
        self.collectionView = collectionView
        self.timeSheet = timeSheet
        self.width = width
        self.height = height
    }
}

// MARK: - UICollectionViewDataSource
extension SumScheduleDatasource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TimesheetsDatasource.timesheetInfors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SumScheduleCell.identifier, for: indexPath) as! SumScheduleCell
        
        guard indexPath.item >= 0 && indexPath.item < TimesheetsDatasource.timesheetInfors.count, let sumTimeSheet = self.timeSheet?.sumOfTimeInCell else {
            return cell
        }
        let timesheetInfor = TimesheetsDatasource.timesheetInfors[indexPath.item]
        
        switch timesheetInfor {
        case .firstCheckIn:
            cell.sumLabel.text = "-"
            break
        case .lastCheckOut:
            cell.sumLabel.text = "-"
            break
        case .hospitalStayTime:
            cell.sumLabel.text = sumTimeSheet.columnInHospitalTime
            break
        case .extendedTime:
            cell.sumLabel.text = sumTimeSheet.columnExtendedTime
            break
        case .overtime:
            cell.sumLabel.text = sumTimeSheet.columnOvertime
            break
        case .otherTime:
            cell.sumLabel.text = sumTimeSheet.columnOtherTime
            break
        case .breaktime:
            cell.sumLabel.text = sumTimeSheet.columnBreakTime
            break
        case .nightWorkTime:
            cell.sumLabel.text = sumTimeSheet.columnNightWorkTime
            break
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SumScheduleDatasource: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.parentController?.spreadsheetView.contentOffset.x = scrollView.contentOffset.x
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SumScheduleDatasource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width ?? 0, height: height ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
