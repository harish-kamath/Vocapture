//
//  LearningVC.swift
//  Vocapture
//
//  Created by Mayank Kishore on 1/26/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit

class LensTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView:UITableView!
    var modules = Array(lenses.keys)
    var searchable = [Searchable]()
    var dictionary = lenses
    
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
        cell.ig.image = searchable[indexPath.row].img.curr_image
        
        cell.progressBar.animateTo(progress: CGFloat(Float.random(in: 0..<1)))
        
        cell.progressBar.barBorderColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:0.0)
        cell.progressBar.barFillColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        cell.progressBar.barBackgroundColor = UIColor(red:0.77, green:0.93, blue:0.78, alpha:0.0)
        cell.progressBar.barBorderWidth = 0.1
        cell.progressBar.barFillInset = 2
        cell.progressBar.labelTextColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        cell.progressBar.progressLabelInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        cell.progressBar.font = UIFont.boldSystemFont(ofSize: 18)
        cell.progressBar.labelPosition = GTProgressBarLabelPosition.right
        cell.progressBar.displayLabel = false
        cell.progressBar.barMaxHeight = 12
        return cell
    }
    
    func populate_cells() {
        for each in modules {
            let module = Module()
            module.name = each
            let image = Image()
            image.curr_image = UIImage(named: module.name!.lowercased())
            
            let elem = Searchable()
            elem.mod = module
            elem.img = image
            self.searchable.append(elem)
        }
        
        tableView.reloadData()
    }
    class Module {
        var name : String?
    }
    
    class Image {
        var curr_image : UIImage?
    }
    
    class Searchable {
        var mod = Module()
        var img = Image()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moduleSelected = modules[indexPath.row]
        
        let moduleView = storyboard?.instantiateViewController(withIdentifier: "moduleView") as! LensDetailVC
        
        moduleView.name = moduleSelected
        moduleView.words = dictionary[moduleSelected]

        
        self.present(moduleView, animated: true, completion: nil)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
