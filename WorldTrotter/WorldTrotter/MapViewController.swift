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
    var pins = [MKPointAnnotation]()
    var pinIndex = 0
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        // Ensure we have access to Location Services
        cl.requestAlwaysAuthorization()
        
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
        findButton.setTitle("Find Me", forState: .Normal)
        findButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        findButton.frame = CGRectMake(15, -50, 300, 500)
        findButton.titleLabel!.text = "Find"
        view.addSubview(findButton)
        let xCenterConstraint = NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: findButton, attribute: .CenterX, multiplier: 1, constant: 0)
        view.addConstraint(xCenterConstraint)
        findButton.translatesAutoresizingMaskIntoConstraints = false
        findButton.addTarget(self, action: "findMe:", forControlEvents: .TouchUpInside)
        let findbottomConstraint = findButton.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor, constant: -20)
       
        findbottomConstraint.active = true

        let cycleButton = UIButton()
        cycleButton.setTitle("CyclePins", forState: .Normal)
        cycleButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        cycleButton.frame = CGRectMake(40, -100, 300, 500)
        cycleButton.titleLabel!.text = "CyclePins"
        view.addSubview(cycleButton)
        let x2CenterConstraint = NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: cycleButton, attribute: .CenterX, multiplier: 1, constant: 0)
        view.addConstraint(x2CenterConstraint)
        cycleButton.translatesAutoresizingMaskIntoConstraints = false
        cycleButton.addTarget(self, action: "cyclePins:", forControlEvents: .TouchUpInside)
        let cyclebottomConstraint = cycleButton.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor, constant: -50)
        
        cyclebottomConstraint.active = true

        
        // Gold Challenge: Add 3 pins on the map
       
        let pin1 = MKPointAnnotation()
        pin1.coordinate =  CLLocationCoordinate2DMake(37.3882601, -122.0302504)
        pin1.title = "Pizza Hut"
 //       MKMapPointForCoordinate(<#T##coordinate: CLLocationCoordinate2D##CLLocationCoordinate2D#>)
        
        let pin2 = MKPointAnnotation()
        pin2.coordinate = CLLocationCoordinate2DMake(37.3854416,-122.0421551)
        pin2.title = "Home"
        let pin3 = MKPointAnnotation()
        pin3.coordinate = CLLocationCoordinate2DMake(40.6892534,-74.0466944)
        pin3.title = "StatueOfLiberty"
        pins = [pin1, pin2, pin3]
        for p in pins {
                mapView.addAnnotation(p)
        }
        
        
        
        
        
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
        
       
        mapView.setUserTrackingMode(.Follow,
            animated: true)
        mapView.showsUserLocation = true
    }
    
    @IBAction func cyclePins(sender: UIButton) {
        print("Cycling throug pins")
        let point = MKMapPointForCoordinate(mapView.annotations[pinIndex].coordinate)
        let pointRect = MKMapRectMake(point.x , point.y, 0.1, 0.1)
        mapView.setVisibleMapRect(pointRect, animated: true)
        pinIndex += 1
        if pinIndex >= 3 {
            pinIndex = 0
        }
        
    }
}
