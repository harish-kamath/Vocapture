//
//  ModuleVC.swift
//  Vocapture
//
//  Created by Harish Kamath on 1/24/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit

class ModuleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet weak var language1 : UILabel!
    @IBOutlet weak var language2 : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WordsCell = tableView.dequeueReusableCell(withIdentifier: "wordscell", for: indexPath) as! WordsCell
        cell.lang1.text = "Hello World!"
        cell.lang2.text = "Hello World!"
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
