//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by FRANCIS HUYNH on 1/3/16.
//  Copyright © 2016 Fhools. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    var fahrenheitValue: Double? {
        didSet {
            updateCelsiusLabel()
        }
    }
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5.0/9.0)
        } else {
            return nil
        }
    }
    
    let numberFormatter: NSNumberFormatter =  {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    let validInputChars: NSCharacterSet = {
        let cs = NSCharacterSet(charactersInString: "0123456789.")
        return cs
    }()
    
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var celsiusLabel: UILabel!
    
    @IBAction func fahrenheitFieldEditingChanged(textField: UITextField) {
        if let text = textField.text, value = Double(text){
            fahrenheitValue = value
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel() {
        if let value = celsiusValue {
            celsiusLabel.text = numberFormatter.stringFromNumber(value)
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ConversionViewController finished loading")
        let timeComponents = NSCalendar.currentCalendar().components(.Hour, fromDate: NSDate())
        let hour = timeComponents.hour
        
        let colors = ["Morning": UIColor.redColor(), "Afternoon" :UIColor.greenColor() , "Evening" : UIColor.darkGrayColor()]
        switch hour {
        case  8...12:
            view.backgroundColor = colors["Morning"]
        case 12...18:
            view.backgroundColor = colors["Afternoon"]
        case 19...23:
            fallthrough
        case 0...7:
            view.backgroundColor = colors ["Evening"]
        default:
            view.backgroundColor = UIColor.whiteColor()
        }
    }
    
    //MARK: UITextField Delegates
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Chapter 4 Bronze Challenge.
        for c in string.utf16 {
            if !validInputChars.characterIsMember(c) {
                return false
            }
        }

        let existingTextHasDecimalSeparator = textField.text?.rangeOfString(".")
        let replacementTextHasDecimalSeparator = string.rangeOfString(".")
        
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            return true
        }
        
    }
}
