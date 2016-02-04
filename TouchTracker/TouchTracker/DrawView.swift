//
//  DrawView.swift
//  TouchTracker
//
//  Created by FRANCIS HUYNH on 1/30/16.
//  Copyright © 2016 Fhools. All rights reserved.
//
import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var finishedCircles = [Circle]()
    var currentCircles = [NSValue:Line]()
    var selectedLineIndex: Int? {
        didSet {
            // If no lines selected, hide the menu since it might be showing
            if selectedLineIndex == nil {
                let menu = UIMenuController.sharedMenuController()
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    var maxVelocity: CGFloat?
    var lastTranslation: CGPoint?
    var moveRecognizer: UIPanGestureRecognizer!
    
    // MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        // If we set .delaysTouchesBegan to false than the first tap
        // of a double tap will cause touchesBegan methods to be called
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        // Add gesture recognizer to select lines
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        tapRecognizer.delaysTouchesBegan = true
        // Require doubleTapRecognizer to fail before singleRapRecognizer will 
        //claim the gesture as its own
        tapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        // Add continuous gesture recognizer for long press
        // A continuous gesture recognizer will repeatedly trigger its action
        // for each state transition.
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        addGestureRecognizer(longPressRecognizer)
        
        // Add Pan Gesture Recognizer
        moveRecognizer = UIPanGestureRecognizer(target: self, action: "moveLine:")
        // Allow pan gesture recognizer to pass through touch events
        moveRecognizer.cancelsTouchesInView = false
        moveRecognizer.delegate = self
        addGestureRecognizer(moveRecognizer)
    }
    
    // MARK: Inspectable Properties
    @IBInspectable var finishedLineColor: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.redColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThicknesss: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Drawing routines
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = line.thickness
        path.lineCapStyle = .Round
        
        path.moveToPoint(line.begin)
        path.addLineToPoint(line.end)
        path.stroke()
    }
    
    func strokeCircle(circle: Circle) {
        let path = UIBezierPath()
        path.lineWidth = lineThicknesss
        path.addArcWithCenter(circle.center, radius: circle.radius, startAngle: 0, endAngle: CGFloat(2.0)*CGFloat(M_PI), clockwise: false)
        path.stroke()
        
    }
    
    // MARK: Line Selection routines
    func indexOfLineAtPoint(point: CGPoint) -> Int? {
        for(index, line) in finishedLines.enumerate() {
            let begin = line.begin
            let end = line.end
            
            // Check every .05 points along the line beteen begin and end to see
            // if distance between the interpolated point and givenPoint 
            // is less than threshold of 20, using parameterized t
            for t in CGFloat(0).stride(to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        return nil
    }
    
    func deleteLine(sender: AnyObject) {
        if let index = selectedLineIndex {
            finishedLines.removeAtIndex(index)
            selectedLineIndex = nil
            setNeedsDisplay()
        }
    }
    override func drawRect(rect: CGRect) {
        finishedLineColor.setStroke()
        for line in finishedLines {
            let vec = CGPoint(x:line.end.x - line.begin.x, y: line.begin.y - line.end.y)
            //print("vec: \(vec)")
            let angle = atan2f(Float(vec.y), Float(vec.x)) * Float(180/M_PI)
            
            //print("angle: \(angle)")
            if (angle < 45) {
                UIColor.purpleColor().setStroke()
            } else if (angle < 90) {
                UIColor.blueColor().setStroke()
            } else if (angle < 125) {
                UIColor.orangeColor().setStroke()
            } else if (angle < 180) {
                UIColor.greenColor().setStroke()
            }
            
            strokeLine(line)
        }
        
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            strokeLine(line)
        }
        
        for c in finishedCircles {
            strokeCircle(c)
        }
        
        if let index = selectedLineIndex {
            UIColor.greenColor().setStroke()
            let selectedLine = finishedLines[index]
            strokeLine(selectedLine)
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: Gesture actions
    func doubleTap(gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        selectedLineIndex = nil
        currentLines.removeAll(keepCapacity: false)
        finishedLines.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }
    
    func tap(gestureRecognizer: UIGestureRecognizer) {
        print("Recognize a single tap")
        let point = gestureRecognizer.locationInView(self)
        selectedLineIndex = indexOfLineAtPoint(point)
        
        // There is only one UIMenuController per app
        let menu = UIMenuController.sharedMenuController()
        
        if selectedLineIndex != nil {
            // Must become first responder before setting up UIMenuController
            becomeFirstResponder()
            
            let deleteItem = UIMenuItem(title: "Delete", action: "deleteLine:")
            menu.menuItems = [deleteItem]
            
            menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 2, height: 2), inView: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            menu.setMenuVisible(false, animated: true)
        }
        
        setNeedsDisplay()
    }
    
    func longPress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == .Began {
            print("Recognized a long press began")
            let point = gestureRecognizer.locationInView(self)
            selectedLineIndex = indexOfLineAtPoint(point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll(keepCapacity: false)
            }
        } else if gestureRecognizer.state == .Ended {
            print("Recognized a long press ended")
            selectedLineIndex = nil
        }
        
        setNeedsDisplay()
    }
    
    
    func moveLine(gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognize a pan")
        let translation = gestureRecognizer.translationInView(self)
        if let index = selectedLineIndex {
            // First attempt at silver challenge bug
            //currentLines.removeAll(keepCapacity: false)
            if gestureRecognizer.state == .Changed {
              
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, inView: self)
                
               
                setNeedsDisplay()
            }
            
        }
        if maxVelocity == nil {
            maxVelocity = 1.0
            lastTranslation = translation
        } else {
            let velocity = hypot(translation.x - lastTranslation!.x,
                translation.y - lastTranslation!.y)
            if maxVelocity < velocity {
                maxVelocity = velocity
            }
            lastTranslation = translation
        }
        
    }
    
    // MARK: UIGestureRecognizerDelegate
    // Allows pan gesture recognizer to continue with long press gesture recognizer
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    // MARK: UIResponder
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(__FUNCTION__)
        
        for touch in touches {
            let location = touch.locationInView(self)
            let newLine = Line(begin: location, end: location, thickness: 1.0)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
            currentCircles[key] = newLine
            
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(__FUNCTION__)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.locationInView(self)
            currentLines[key]?.thickness = maxVelocity!
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(__FUNCTION__)
        var points = [CGPoint]()
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.locationInView(self)
                line.thickness = maxVelocity!
                finishedLines.append(line)
                currentLines.removeValueForKey(key)
            }
            if var point = currentCircles[key] {
                point.end = touch.locationInView(self)
                points.append(point.end)
            }
            
        }
        
        if points.count > 1 {
            let x = points[0].x + (points[1].x - points[0].x) / 2.0
            let y = points[0].y + (points[1].y - points[0].y) / 2.0
            let radius = hypot(points[1].x - points[0].x, points[1].y - points[0].y)
            finishedCircles.append(Circle(radius: radius, center: CGPoint(x: x, y: y)))
        }
        maxVelocity = nil
        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print(__FUNCTION__)
        currentLines.removeAll()
        currentCircles.removeAll()
        setNeedsDisplay()
        
    }
}
