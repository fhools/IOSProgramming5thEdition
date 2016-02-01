//
//  DrawView.swift
//  TouchTracker
//
//  Created by FRANCIS HUYNH on 1/30/16.
//  Copyright © 2016 Fhools. All rights reserved.
//
import UIKit

class DrawView: UIView {
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var finishedCircles = [Circle]()
    var currentCircles = [NSValue:Line]()
    
    // MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        // If we set .delaysTouchesBegan to false than the first tap
        // of a double tap will cause touchesBegan methods to be called
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
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
    
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThicknesss
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
    
    override func drawRect(rect: CGRect) {
        finishedLineColor.setStroke()
        for line in finishedLines {
            let vec = CGPoint(x:line.end.x - line.begin.x, y: line.begin.y - line.end.y)
            print("vec: \(vec)")
            let angle = atan2f(Float(vec.y), Float(vec.x)) * Float(180/M_PI)
            
            print("angle: \(angle)")
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
    }
    
    // MARK: Gesture actions
    func doubleTap(gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        currentLines.removeAll(keepCapacity: false)
        finishedLines.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }
    
    // MARK: UIResponder
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(__FUNCTION__)
        
        for touch in touches {
            let location = touch.locationInView(self)
            let newLine = Line(begin: location, end: location)
            
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
        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print(__FUNCTION__)
        currentLines.removeAll()
        currentCircles.removeAll()
        setNeedsDisplay()
        
    }
}
