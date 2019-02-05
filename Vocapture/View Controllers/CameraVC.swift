//
//  CameraVC.swift
//  Vocapture
//
//  Created by Harish Kamath on 1/24/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit

class CameraVC: UIViewController {

    @IBOutlet weak var LearningButton: UIButton!
    @IBOutlet weak var ModulesButton: UIButton!
    @IBOutlet weak var SettingsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func expandMenu(_ sender:UIButton){
        if(LearningButton.alpha < 1){
            UIView.animate(withDuration: 0.5, animations: {
            self.LearningButton.alpha = 1
            self.ModulesButton.alpha = 1
            self.SettingsButton.alpha = 1
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 0.5, animations: {
                self.LearningButton.alpha = 0
                self.ModulesButton.alpha = 0
                self.SettingsButton.alpha = 0
            }, completion: nil)
            
        }
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
