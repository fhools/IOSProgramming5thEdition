//
//  PhotosViewController.swift
//  Phororama
//
//  Created by FRANCIS HUYNH on 2/6/16.
//  Copyright © 2016 Fhools. All rights reserved.
//

import Foundation
import UIKit

class PhotosViewController : UIViewController {
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            // This block gets called once we have processed rest API 
            // and receivedd a list of recent photos and their URLs
            // We then retrieved the very first image
            switch photosResult {
            case let .Success(photos):
                print("Successfully found \(photos.count) recent photos")
                if let firstPhoto = photos.first {
                    self.store.fetchImageForPhoto(firstPhoto) {
                      (imageResult) -> Void in
                        switch imageResult {
                        case let .Success(image):
                            //self.imageView.image = image
                            // Force operation to run on Main UI Thread
                            // This implies that the block is running on some
                            // side thread??
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.imageView.image = image
                            }
                        case let .Failure(error):
                            print("Error downloading Image: \(error)")
                        }
                    }
                }
            case let .Failure(error):
                print("Error fetching recent photos: \(error)")
            }
        }
    }
}