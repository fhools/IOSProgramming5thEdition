//
//  ViewController.swift
//  WorldTrotter
//
//  Created by FRANCIS HUYNH on 1/1/16.
//  Copyright © 2016 Fhools. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 160, y: 240, width: 100, height: 150)
        let subview = UIView(frame: frame)
        subview.backgroundColor = UIColor.blueColor()
        view.addSubview(subview)
        
        let subview2 = UIView(frame: CGRect(x: 20, y: 30, width: 50, height: 50))
        subview2.backgroundColor = UIColor.greenColor()
        subview.addSubview(subview2)
    }

   

}

