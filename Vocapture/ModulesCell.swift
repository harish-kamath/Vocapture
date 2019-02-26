//
//  ModulesCell.swift
//  Vocapture
//
//  Created by Mayank Kishore on 2/26/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit

class ModulesCell: UITableViewCell {

    @IBOutlet weak var progressBar: GTProgressBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progressBar.progress = 1
        progressBar.barBorderColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.barFillColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.barBackgroundColor = UIColor(red:0.77, green:0.93, blue:0.78, alpha:1.0)
        progressBar.barBorderWidth = 1
        progressBar.barFillInset = 2
        progressBar.labelTextColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.progressLabelInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        progressBar.font = UIFont.boldSystemFont(ofSize: 18)
        progressBar.labelPosition = GTProgressBarLabelPosition.right
        progressBar.displayLabel = false
        progressBar.barMaxHeight = 12
        progressBar.direction = GTProgressBarDirection.anticlockwise
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
