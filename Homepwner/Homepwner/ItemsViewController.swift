//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by FRANCIS HUYNH on 1/12/16.
//  Copyright © 2016 Fhools. All rights reserved.
//

import UIKit

class ItemsViewController : UITableViewController {

    var itemStore: ItemStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // We want the tableview to appear below the status bar area at the top of
        // the screen
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets 
    }
    
    // MARK: UITableViewControllerDataSource
    //Note: DataSource is the Model part of MVC
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = itemStore.allItems.count
        // Silver challenge: We always have last row be No more items
        return count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Value1 is big textlabel and detailtextlabel side by side with icon on left as well
        // Note: resuseIdentifier is a unique string for each cell that look alike. 
        
        // Q: Does framework register this string?
        // A: According to BigNerdRanch, the convention is every class that implements UITableViewCell has the name of
        // its reuseidentifier be that of the class.
        
        // Q: Why don't we create our own reuseidentifier?
        // A: Wrong question, we did set its reuseidentfier when we instantiate it, thats the "reuseidentifier" parameter
        
        // Q: Ok, the reuseidentifier is used by a TableView not UITableViewController, how does that get associated then
        // A: UITableViewCell's identifier attribute in the InterfaceBuilder of the "prototype cell"
        
        // Q: Can we have multiple "prototype cells per tableview???"
        // A: TableView has a property  you can set in interface builder number of prototype cells. Thats how you can set
        // the attributes for different type of cells you have from the gui.

        
        // The following is inefficient because it creates a new cell for each row of the tableview data
        //let cell = UITableViewCell(style: .Value1, reuseIdentifier: "UITableViewCell")
        
        // The following uses the UITableView's queue of identifier it automatically manages
        // Note: If we don't set tableview's prototype cell's attribute to UITableView, it wouldn't have known!
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        if indexPath.row < itemStore.allItems.count {
            let item = itemStore.allItems[indexPath.row]
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        } else {
            cell.textLabel?.text = "No more items"
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    
}
