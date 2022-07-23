//
//  ViewController.swift
//  Plan
//
//  Created by Seth Ledford on 7/20/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView! // Table View IBOutlet
    var dataArray:[String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        //tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        myCell.entryTextView!.text = dataArray[indexPath.row]
        
        // set the closure
        weak var tv = tableView
        myCell.callback = { [weak self] str in
            guard let self = self, let tv = tv else { return }
            // print("called back", str)
            // update our data with the edited string
            // self.myData[indexPath.row] = str --> modify data/stored data when text is changed
            // we don't need to do anything else here
            // this will force the table to recalculate row heights
            tv.performBatchUpdates(nil) // CURRENTLY ANIMATED. IF YOU DON'T IMPLEMENT VISIBLE BACKGROUNDS, CONSIDER REMOVING ANIMATION TO REDUCE LOAD ON THE SYSTEM/INCREASE SPEED
        }
        
        myCell.callback2 = {
            self.dataArray.append("")
            tableView.reloadData()
            myCell.entryTextView.becomeFirstResponder()
        }
        
        return myCell
        
    }
    
    func dataFromPropertyList(){
        let path = Bundle.main.path(forResource: "EntryData", ofType: "plist")
        let dict:AnyObject = NSDictionary(contentsOfFile: path!)!
        
        dataArray = dict.object(forKey: "entriesData") as! Array<String>
        
    }

}

