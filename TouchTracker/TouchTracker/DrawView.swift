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
    }
    
    // MARK: UIResponder
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(__FUNCTION__)
        
        for touch in touches {
            let location = touch.locationInView(self)
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
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
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.locationInView(self)
                               finishedLines.append(line)
                currentLines.removeValueForKey(key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print(__FUNCTION__)
        currentLines.removeAll()
        setNeedsDisplay()
        
    }
}
