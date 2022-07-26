//
//  ViewController.swift
//  Plan
//
//  Created by Seth Ledford on 7/20/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Create Table View IBOutlet
    @IBOutlet weak var tableView: UITableView!
    // Create "dataArray" String Array which stores the text for all entries in the plan.
    var dataArray:[String] = [""]
    @IBAction func newCellBTN(_ sender: UIButton) {
        CATransaction.begin()
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: dataArray.count, section: 0)], with: UITableView.RowAnimation.automatic)
        self.dataArray.insert("", at: dataArray.count)
        CATransaction.setCompletionBlock {
            // Code to be executed upon completion
            self.tableView.reloadData() // Using reload data after calling delete is an inefficient way to maintain accurrate indexPath.row tracking. Temporary solution. Definitely will cause slowdown.
        }
        tableView.endUpdates()
        CATransaction.commit()
    }
    
    
    // View Did Load (commands and functions to run during start up)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        //tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        fetchData()
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { (notification) in
            //print("app did enter background")
            self.saveData()
        }
        
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Table View Function
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Upon loading, tell the Table View how many rows/cells to create
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    // For each given cell in the Table View, do the following:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        myCell.entryTextView!.text = dataArray[indexPath.row]
        
        // set the closure
        weak var tv = tableView
        myCell.handleNewDataCB = { [weak self] str in
            guard let self = self, let tv = tv else { return }
            // print("called back", str)
            // update our data with the edited string
            //print("dataArray: ", self.dataArray)
            //print("indexPath.row: ", indexPath.row)
            self.dataArray[indexPath.row] = str // --> modify data/stored data when text is changed
            
            // we don't need to do anything else here
            // this will force the table to recalculate row heights
            tv.performBatchUpdates(nil) // CURRENTLY ANIMATED. IF YOU DON'T IMPLEMENT VISIBLE BACKGROUNDS, CONSIDER REMOVING ANIMATION TO REDUCE LOAD ON THE SYSTEM/INCREASE SPEED
            //self.saveDataToPropertyList()
        }
        
        // Upon receiving the "New Line" callback method from my 'Custom Cell' class, do the following:
        myCell.newLineCB = {
            
            CATransaction.begin()
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: 0)], with: UITableView.RowAnimation.automatic)
            self.dataArray.insert("", at: indexPath.row + 1)
            CATransaction.setCompletionBlock {
                // Code to be executed upon completion
                tableView.reloadData() // Using reload data after calling delete is an inefficient way to maintain accurrate indexPath.row tracking. Temporary solution. Definitely will cause slowdown.
            }
            tableView.endUpdates()
            CATransaction.commit()
          
            //tableView.reloadData()
            //self.saveDataToPropertyList()
            //myCell.entryTextView.becomeFirstResponder()
        }
        return myCell
    }
    
    // Allow for a Table View row to be deleted
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Implements functionality for Table View row deletion.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            CATransaction.begin()
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            dataArray.remove(at: indexPath.row)
            CATransaction.setCompletionBlock {
                // Code to be executed upon completion
                tableView.reloadData() // Using reload data after calling delete is an inefficient way to maintain accurrate indexPath.row tracking. Temporary solution. Definitely will cause slowdown.
            }
            tableView.endUpdates()
            CATransaction.commit()
            // handle delete (by removing the data from your array and updating the tableview)
            
            //saveDataToPropertyList()
        }
    }
    
    // Store the relevant contents of the "EntryData" Plist, inside of our 'dataArray'
    func fetchData(){
        let defaults = UserDefaults.standard
        dataArray = defaults.object(forKey: "dataArray") as? [String] ?? [String]()
    }
    func saveData(){
        let defaults = UserDefaults.standard
        defaults.set(dataArray, forKey: "dataArray")
        //print("save data called.")
    }
    
}

