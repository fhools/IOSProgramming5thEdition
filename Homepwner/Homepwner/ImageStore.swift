//
//  ImageStore.swift
//  Homepwner
//
//  Created by FRANCIS HUYNH on 1/24/16.
//  Copyright © 2016 Fhools. All rights reserved.
//

import UIKit

class ImageStore {
    let cache = NSCache()
    
    
    func imageURLForKey(key: String) -> NSURL {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent(key)
        
    }
    
    func setImage(image: UIImage, forKey key: String) {
        // Set it in our cache
        cache.setObject(image, forKey: key)
        
        let imageURL = imageURLForKey(key)
        
        // Write it to disk
        //var data = UIImageJPEGRepresentation(image, 0.5)
        let data = UIImagePNGRepresentation(image)
        if let data = data {
            data.writeToURL(imageURL, atomically: true)
        }
    }
    
    func imageForKey(key: String) -> UIImage? {
        
        // Is it in our cache, if so return the cached image
        if let existingImage = cache.objectForKey(key) as? UIImage {
            return existingImage
        }
        
        // See if its on the disk
        let imageURL = imageURLForKey(key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
            return nil
        }
        cache.setObject(imageFromDisk, forKey: key)
        return imageFromDisk
    }
    
    func deletImageForKey(key: String) {
        cache.removeObjectForKey(key)
        let imageURL = imageURLForKey(key)
        do {
            try NSFileManager.defaultManager().removeItemAtURL(imageURL)
        }
        catch {
            print("Error removing the image from disk: \(error)")
        }
    }


}