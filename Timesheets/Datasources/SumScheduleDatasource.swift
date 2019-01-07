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
    
    var schedules: [[CGFloat]] = []
    
    var numberOfItems: Int?
    
    weak var parentController: ViewController?
    
    var collectionView: UICollectionView?
    
    init(parentController: ViewController, collectionView: UICollectionView, schedules: [[CGFloat]], numberOfItems: Int, width: CGFloat, height: CGFloat) {
        super.init()
        
        self.parentController = parentController
        self.collectionView = collectionView
        self.schedules = schedules
        self.numberOfItems = numberOfItems
        self.width = width
        self.height = height
    }
}

// MARK: - UICollectionViewDataSource
extension SumScheduleDatasource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SumScheduleCell.identifier, for: indexPath) as! SumScheduleCell
        cell.sumLabel.text = "54:26"
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
