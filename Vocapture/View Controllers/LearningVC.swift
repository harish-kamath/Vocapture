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
    var modules = ["School", "Kitchen", "Office", "Household", "Food", "Bathroom", "Recreation", "Animals", "Furniture", "Signals", "Technology", "Shopping", "Vehicles"]
    var searchable = [Searchable]()
    var dictionary = [
        "School" : ["person", "bicycle", "backpack", "book", "scissors", "clock", "cell phone",        "keyboard", "laptop", "chair", "dining table", "handbag", "umbrella", "bottle"],
        "Kitchen" : ["bottle", "person", "wine glass", "cup", "fork", "knife", "spoon", "bowl", "chair", "couch", "potted plant", "dining table", "microwave", "oven", "toaster", "sink", "refrigerator", "vase"],
        "Office" : ["person", "backpack", "clock", "cell phone", "keyboard", "laptop", "chair", "dining table", "handbag", "umbrella", "tie", "suitcase"],
        "Household" : ["microwave", "oven", "toaster", "sink", "refrigerator", "chair", "couch", "potted plant", "bed", "dining table", "toilet"],
        "Food" : ["banana", "apple", "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza", "donut", "cake"],
        "Bathroom" : ["hair drier", "toothbrush", "toilet", "sink", "potted plant"],
        "Recreation" : ["frisbee", "skis", "snowboard", "sports ball", "kite", "baseball bat", "baseball", "glove", "skateboard", "surfboard", "tennis racket"],
        "Animals" : ["bird", "cat", "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe"],
        "Furniture" : ["chair", "couch", "potted plant", "bed", "dining table", "toilet", "microwave", "oven", "toaster", "sink", "refrigerator"],
        "Signals" : ["traffic light", "fire hydrant", "stop sign", "parking meter", "bench"],
        "Technology" : ["tv", "laptop", "mouse", "remote", "keyboard", "cell phone"],
        "Shopping" : ["backpack", "umbrella", "handbag", "tie", "vase", "bottle", "wine", "glass", "cup", "fork", "knife", "spoon", "bowl"],
        "Vehicles" : ["bicycle", "car", "motorcycle", "airplane", "bus", "train", "truck", "boat"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        populate_cells()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ModulesCell = tableView.dequeueReusableCell(withIdentifier: "modulescell", for: indexPath) as! ModulesCell
        cell.labelText.text = searchable[indexPath.row].mod.name
        cell.progressBar.progress = 0
//        cell.progressBar.animateTo(progress: 0.9)
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
    
    func populate_cells() {
        for each in modules {
            let module = Module()
            module.name = each
            let elem = Searchable()
            elem.mod = module
            self.searchable.append(elem)
        }
        tableView.reloadData()
    }
    
    class Module {
        var name : String?
    }
    
    class Searchable {
        var mod = Module()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moduleSelected = modules[indexPath.row]
        
        let moduleView = storyboard?.instantiateViewController(withIdentifier: "moduleView") as! ModuleVC
        
        moduleView.name = moduleSelected
        moduleView.words = dictionary[moduleSelected]

        
        self.present(moduleView, animated: true, completion: nil)
        
        
        
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
