//
//  PhotoStore.swift
//  Phororama
//
//  Created by FRANCIS HUYNH on 2/6/16.
//  Copyright © 2016 Fhools. All rights reserved.
//

import Foundation
import UIKit
enum ImageResult {
    case Success(UIImage)
    case Failure(ErrorType)
}

enum PhotoError: ErrorType {
    case ImageCreationError
}

class PhotoStore {
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    // Spawns a URL request tasks. This tasks will will take in a URL request, 
    // when it asynchronously retrieves the URL data. It will process the json
    // body via processReccentPhotoRequest. It will then pass the results of this
    // as an argument to a closure as a PhotoResults.
    func fetchRecentPhotos(completion completion: (PhotosResult) -> Void) {
        let url = FlickrAPI.recentPhotosURL()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            let result = self.processRecentPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    // This takes in data from a url request and uses the flicker API to transform it
    // into a PhotoResult.
    func processRecentPhotosRequest(data data: NSData?, error: NSError?) -> PhotosResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        return FlickrAPI.photosFromJSONData(jsonData)
    }
    
    // Given a Photo instance, and a closure. Requests the Image from the photo URL asynchronously.
    // calling processImageRequest to transform it into a UIImage and passing that to
    // the closure.
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult) -> Void) {
        // Given Photo object, retrieve the image from URL
        // and store it in UIImage,
        print(#function, "url = \(photo.remoteURL)")
        let photoURL = photo.remoteURL
        let request = NSURLRequest(URL: photoURL)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            if case let .Success(image) = result {
                photo.image = image
            }
            completion(result)
        }
        task.resume()
    }

    // Transform data from URL request into actual UI Image object, wrapping it in a ImageResult.
    func processImageRequest(data data: NSData?, error: NSError?) -> ImageResult {
        guard let
            imageData = data,
            image = UIImage(data: imageData) else {
                if data == nil {
                    return .Failure(error!)
                } else {
                    return .Failure(PhotoError.ImageCreationError)
                }
        }
        return .Success(image)
    }
    
    }


