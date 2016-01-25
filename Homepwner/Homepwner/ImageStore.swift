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
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key)
    }
    
    func imageForKey(key: String) -> UIImage? {
        return cache.objectForKey(key) as? UIImage
    }
    
    func deletImageForKey(key: String) {
        cache.removeObjectForKey(key)
    }


}