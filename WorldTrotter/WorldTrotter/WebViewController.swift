//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by FRANCIS HUYNH on 1/7/16.
//  Copyright © 2016 Fhools. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        print("WebViewController finished loading")
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.google.com")!))
    }
}