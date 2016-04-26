//
//  Photo.swift
//  Phororama
//
//  Created by FRANCIS HUYNH on 2/6/16.
//  Copyright © 2016 Fhools. All rights reserved.
//

import Foundation
import UIKit
class Photo {
    let title: String
    let remoteURL: NSURL
    let photoID: String
    let dateTaken: NSDate
    var image: UIImage?
    
    init(title: String, photoID: String, remoteURL: NSURL, dateTaken: NSDate) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}