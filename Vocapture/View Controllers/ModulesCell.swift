//
//  ModulesCell.swift
//  Vocapture
//
//  Created by Mayank Kishore on 2/26/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit

class ModulesCell: UITableViewCell {

    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var progressBar: GTProgressBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
