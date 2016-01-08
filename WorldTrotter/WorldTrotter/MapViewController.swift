//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by FRANCIS HUYNH on 1/5/16.
//  Copyright © 2016 Fhools. All rights reserved.
//

import UIKit
import MapKit
class MapViewController : UIViewController {
    
    var mapView: MKMapView!
    override func loadView() {
        mapView = MKMapView()
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view")
    }
    
}
