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
        fetchDataFromPropertyList()
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { (notification) in
            //print("app did enter background")
            self.saveDataToPropertyList()
        }
        
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
            print("dataArray: ", self.dataArray)
            print("indexPath.row: ", indexPath.row)
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
    func fetchDataFromPropertyList(){
        let path = Bundle.main.path(forResource: "EntryData", ofType: "plist")
        let dict:AnyObject = NSDictionary(contentsOfFile: path!)!
        dataArray = dict.object(forKey: "entriesArray") as! Array<String>
        
    }
    
    // Save the contents of 'dataArray' to the EntryData Plist.
    func saveDataToPropertyList(){
        /*let path = Bundle.main.path(forResource: "EntryData", ofType: "plist")
        let tempArray:[String]? = dataArray
        
        if let tempArray = tempArray,
            dataArray = tempArray as? NSArray {
          // use the NSArray list here
        }
        
        let newDataArray = dataArray as! NSMutableArray
        
        newDataArray.write(toFile: path!, atomically: true)*/
        //let string = try? decoder.decode(String.self, from: data)
        
        //PropertyListDecoder().decode(Array<String>.self, from: d)
        do {
            var dictionary = try loadPropertyList()
            dictionary.updateValue(dataArray, forKey: "Root")
            try savePropertyList(dictionary)
        } catch {
            print(error)
        }
        print("save data called.")
    }

    var plistURL : URL {
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL.appendingPathComponent("dictionary.plist")
    }
    
    func savePropertyList(_ plist: Any) throws
    {
        let plistData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        try plistData.write(to: plistURL)
    }


    func loadPropertyList() throws -> [String:[String]]
    {
        let data = try Data(contentsOf: plistURL)
        guard let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String:[String]] else {
            return [:]
        }
        return plist
    }
    
}

