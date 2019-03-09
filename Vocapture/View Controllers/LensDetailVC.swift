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
    @IBOutlet var select:UIButton!
    
    var name:String?
    var words:[String]?
    var searchable = [Searchable]()
    
    @IBAction func didSelect(){
        UserDefaults.standard.set(moduleName.text!, forKey: "VCPLens")
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        moduleName.text = name
        
        if(UserDefaults.standard.string(forKey: "VCPLens")! == name){
            select.isHidden = true
        }
        
        select.layer.cornerRadius = 5
        select.layer.borderWidth = 1
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
        
        let currLang = Language(dictionary: UserDefaults.standard.object(forKey: "VCPLang") as! [String : String])!
        let p = ROGoogleTranslateParams(source: "en",
                                        target: currLang.abbreviation,
                                        text: cell.lang1.text!)
        translator.translate(params: p, callback:{(result) in
            DispatchQueue.main.async {
                cell.lang2.text = result
            }
            
        })
        let progress = Float(UserDefaults.standard.integer(forKey: moduleName.text!+"-"+searchable[indexPath.row].w.name!))/Float(5)
        if(progress < 0){
            UIView.animate(withDuration: 0.2, animations: {
                cell.contentView.backgroundColor = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: -1*CGFloat(progress))
            })
        }
        else{
            UIView.animate(withDuration: 0.2, animations: {
                cell.contentView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: CGFloat(progress))
            })
            
        }
        
        return cell
    }
    
    @IBAction func done(){
        self.dismiss(animated: true, completion: nil)
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
