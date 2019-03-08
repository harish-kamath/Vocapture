//
//  ModuleVC.swift
//  Vocapture
//
//  Created by Harish Kamath on 1/24/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit

class LensDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet weak var moduleName: UILabel!
    
    var name:String?
    var words:[String]?
    var searchable = [Searchable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        moduleName.text = name
        populate_cells()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WordsCell = tableView.dequeueReusableCell(withIdentifier: "wordscell", for: indexPath) as! WordsCell
        cell.lang1.text = searchable[indexPath.row].w.name?.capitalized
        cell.lang2.text = "Translated!"
        let progress = Float.random(in: -1..<1)
        
        
        if(progress < 0){
            UIView.animate(withDuration: 0.2, animations: {
                cell.contentView.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: CGFloat(-1*progress))
            })
        }
        else{
            UIView.animate(withDuration: 0.2, animations: {
                cell.contentView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: CGFloat(progress))
            })
            
        }
        
        return cell
    }
    
    func populate_cells() {
        for each in words! {
            let word = Words()
            word.name = each
            let elem = Searchable()
            elem.w = word
            self.searchable.append(elem)
        }
        
        tableView.reloadData()
    }
    
    class UnderlinedLabel: UILabel {
        
        override var text: String? {
            didSet {
                guard let text = text else { return }
                let textRange = NSMakeRange(0, text.count)
                let attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
                // Add other attributes if needed
                self.attributedText = attributedText
            }
        }
    }
    
    class Words {
        var name : String?
    }
    
    class Searchable {
        var w = Words()
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
