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
    let cl = CLLocationManager()
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        // Create segment control
        let segmentControl = UISegmentedControl(items: [ "Standard", "Hybrid", "Satellite"])
        segmentControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        view.addSubview(segmentControl)
        
        // Setup auto layout constraints
        let topConstraint = segmentControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 8)
        
        let margin = view.layoutMarginsGuide
        let leadingConstraint = segmentControl.leadingAnchor.constraintEqualToAnchor(margin.leadingAnchor)
        let trailingConstraint = segmentControl.trailingAnchor.constraintEqualToAnchor(margin.trailingAnchor)
        
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
        
        
        // Add zoom in and out button
        let findButton = UIButton()
        findButton.setTitle("✸", forState: .Normal)
        findButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        findButton.frame = CGRectMake(15, -50, 300, 500)
        findButton.titleLabel!.text = "Find"
        view.addSubview(findButton)
        let xCenterConstraint = NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: findButton, attribute: .CenterX, multiplier: 1, constant: 0)
        view.addConstraint(xCenterConstraint)
        findButton.translatesAutoresizingMaskIntoConstraints = false
        findButton.addTarget(self, action: "findMe:", forControlEvents: .TouchUpInside)
        let bottomConstraint = findButton.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor, constant: -20)
       
        bottomConstraint.active = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view")
    }
    
    @IBAction func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break
        }
        
    }
    
    @IBAction func findMe(stepper: UIButton) {
        print("User pressed find me")
        
        cl.requestAlwaysAuthorization()
        mapView.setUserTrackingMode(.Follow,
            animated: true)
        mapView.showsUserLocation = true
    }
}
