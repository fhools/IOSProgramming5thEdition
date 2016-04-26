//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let constStr = str

// constStr = "Not allowed to reassign constant"


// Initializer
let emptyString = String()
let emptyArrayOfInts = [Int]()
let emptySetOfFloats = Set<Float>()

let defaultNumber = Int()
let defaultBool = Bool()

let number = 42
let meaningOfLife = String(number)

let availableRooms = Set([204, 411, 412])

let defaultFloat = Float()
let floatFromLiteral = Float(3.14)

let easyPi = 3.14


let floatFromDouble = Float(easyPi)

// Optionals
var reading1: Float?
var reading2: Float?
var reading3: Float?

reading1 = 5
reading2 = 10
reading3 = 15
//let avgReading = (reading1! + reading2! + reading3!)

if let r1 = reading1, r2 = reading2, r3 = reading3 {
    let avgReading = (r1 + r2 + r3) / 3
    print("Average reading is \(avgReading)")
} else {
    print("Couldn't get all readings")
}

import AVFoundation
let url = NSURL(string: "http://cp.usa4.fastcast4u.com:2199/tunein/ddeepo05.pls")
let player = AVPlayer(URL: url!)
player
// Without the following two lines. Xcode Playground will garbage collect all objects, including our
// player object.
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true


