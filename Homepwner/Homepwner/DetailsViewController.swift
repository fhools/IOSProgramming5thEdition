//
//  DetailsViewController.swift
//  Homepwner
//
//  Created by FRANCIS HUYNH on 1/23/16.
//  Copyright © 2016 Fhools. All rights reserved.
//

import UIKit
class BorderedUITextField : UITextField {
    var oldBorderStyle : UITextBorderStyle = .None
    
    override func becomeFirstResponder() -> Bool {
        print("becomeFirstResponder")
        oldBorderStyle = borderStyle
        borderStyle = .Line
        return super.becomeFirstResponder()
        
    }
    
    override func resignFirstResponder() -> Bool {
        print("resignFirstResponder")
        let result = super.resignFirstResponder()
        borderStyle = oldBorderStyle
        return result
    }
}

class DetailViewController: UIViewController, UITextFieldDelegate{
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    let numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
        
    }()
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var serialNumberField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: UIViewController
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
        dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder status
        view.endEditing(true)
        // Write back changes to underlyig item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text, value = numberFormatter.numberFromString(valueText) {
            item.valueInDollars = value.integerValue
        } else {
            item.valueInDollars = 0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ModifyDate" {
            let dateViewController = segue.destinationViewController as! DateViewController
            dateViewController.item = item
        }
    }
    
    //MARK: UITextFieldDelegate
    // NOTE: How does a text field assign its delegate? In InterfaceBuilder do the hookup!
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // There is only one First Responder at a time. If the user
        // presses return then give up first responder status
        textField.resignFirstResponder()
        return true
    }
}