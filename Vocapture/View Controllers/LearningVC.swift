//
//  LearningVC.swift
//  Vocapture
//
//  Created by Mayank Kishore on 1/26/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit

class LearningVC: UIViewController {
    @IBOutlet var wordsLearned: UIButton!
    @IBOutlet var modules: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordsLearned.layer.cornerRadius = 4
        modules.layer.cornerRadius = 4
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
