//
//  LearningVC.swift
//  Vocapture
//
//  Created by Mayank Kishore on 1/26/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit
import GTProgressBar

class LearningVC: UIViewController {
    @IBOutlet var wordsLearned: UIButton!
    @IBOutlet var modules: UIButton!
    @IBOutlet weak var progressBar: GTProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordsLearned.layer.cornerRadius = 4
        modules.layer.cornerRadius = 4
        
        progressBar.progress = 1
        progressBar.barBorderColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.barFillColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.barBackgroundColor = UIColor(red:0.77, green:0.93, blue:0.78, alpha:1.0)
        progressBar.barBorderWidth = 1
        progressBar.barFillInset = 2
        progressBar.labelTextColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.progressLabelInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
