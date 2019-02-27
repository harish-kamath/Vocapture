//
//  LearningVC.swift
//  Vocapture
//
//  Created by Mayank Kishore on 1/26/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit

class LearningVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var wordsLearned: UIButton!
    @IBOutlet var modules: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordsLearned.layer.cornerRadius = 4
        modules.layer.cornerRadius = 4
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ModulesCell = tableView.dequeueReusableCell(withIdentifier: "modulescell", for: indexPath) as! ModulesCell
        cell.labelText.text = "Module 1"
        cell.progressBar.progress = 1
        cell.progressBar.barBorderColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        cell.progressBar.barFillColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        cell.progressBar.barBackgroundColor = UIColor(red:0.77, green:0.93, blue:0.78, alpha:1.0)
        cell.progressBar.barBorderWidth = 1
        cell.progressBar.barFillInset = 2
        cell.progressBar.labelTextColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        cell.progressBar.progressLabelInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        cell.progressBar.font = UIFont.boldSystemFont(ofSize: 18)
        cell.progressBar.labelPosition = GTProgressBarLabelPosition.right
        cell.progressBar.displayLabel = false
        cell.progressBar.barMaxHeight = 12
        cell.progressBar.direction = GTProgressBarDirection.anticlockwise
        return cell
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
