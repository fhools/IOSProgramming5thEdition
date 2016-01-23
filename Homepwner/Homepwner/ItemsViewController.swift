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
    
    @IBAction func addNewItem(sender: AnyObject) {
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.indexOf(newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        if editing {
            // Change text of button to Edit
            sender.setTitle("Edit", forState: .Normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", forState: .Normal)
            setEditing(true, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // We want the tableview to appear below the status bar area at the top of
        // the screen
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        // Place tableview below battery status bar
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    // MARK: UITableViewControllerDataSource
    // Note: DataSource is the Model part of MVC
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        cell.updateLabels()
        if indexPath.row < itemStore.allItems.count {
            let item = itemStore.allItems[indexPath.row]
            cell.nameLabel?.text = item.name
            cell.serialNumberLabel?.text = item.serialNumber
            cell.valueLabel?.text = "$\(item.valueInDollars)"
            if item.valueInDollars < 50 {
                cell.valueLabel.textColor = UIColor.greenColor()
            } else {
                cell.valueLabel.textColor = UIColor.redColor()
            }
        } else {
            cell.nameLabel?.text = "No more items"
            cell.serialNumberLabel?.text = ""
            cell.valueLabel?.text = ""
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
             let item = itemStore.allItems[indexPath.row]
            let ac = UIAlertController(title: "Delete \(item.name)", message: "Are you sure you want to delete this item?", preferredStyle: .ActionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Destroy", style: .Destructive) { (action) -> Void in
                
                self.itemStore.removeItem(item)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            
            ac.addAction(cancelAction)
            ac.addAction(deleteAction)
            presentViewController(ac, animated: true, completion: nil)
            
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !(indexPath.row == itemStore.allItems.count)
    }
    // MARK: UITableViewControllerDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < itemStore.allItems.count {
            return 60
        } else {
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if proposedDestinationIndexPath.row == itemStore.allItems.count {
            return NSIndexPath(forRow: proposedDestinationIndexPath.row - 1,  inSection: 0)
        } else {
            return proposedDestinationIndexPath
        }
    }
    
    
}
