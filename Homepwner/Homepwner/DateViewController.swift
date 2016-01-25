//
//  DateViewController.swift
//  Homepwner
//
//  Created by FRANCIS HUYNH on 1/24/16.
//  Copyright © 2016 Fhools. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    var item: Item!
    override func viewWillAppear(animated: Bool) {
        datePicker.date = item.dateCreated
    }
    override func viewWillDisappear(animated: Bool) {
        item.dateCreated =  datePicker.date
    }
}
