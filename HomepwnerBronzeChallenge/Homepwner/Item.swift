//
//  Item.swift
//  Homepwner
//
//  Created by FRANCIS HUYNH on 1/16/16.
//  Copyright © 2016 Fhools. All rights reserved.
//

import UIKit

// NOTE: Lets figure out what the app needs from NSObject
class Item: NSObject {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: NSDate
    
    // NOTE: init is required because not all properties are initialized with default property when declared
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.dateCreated = NSDate()
        
        // NOTE: This is opposite of C++ where base constructor is always
        // initialized first
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomDollarAmount = Int(arc4random_uniform(100))
            let randomSerialNumber = NSUUID().UUIDString.componentsSeparatedByString("-").first!
            
            self.init(name: randomName, serialNumber: randomSerialNumber, valueInDollars: randomDollarAmount)
        
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
    
    
}