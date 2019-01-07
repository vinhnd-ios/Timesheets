//
//  SumScheduleCell.swift
//  Timesheets
//
//  Created by VINHND on 1/5/19.
//  Copyright © 2019 VINHND. All rights reserved.
//

import UIKit
import SpreadsheetView

class SumScheduleCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sumLabel: UILabel!
    
    static let identifier = String(describing: SumScheduleCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
