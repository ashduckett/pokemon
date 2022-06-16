//
//  CustomImageView.swift
//  Pokemon
//
//  Created by Ash Duckett on 15/06/2022.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
let spinner = UIActivityIndicatorView(style: .medium)
class CustomImageView: UIImageView {
    var task: URLSessionDataTask!
    
    func loadImage(from url: URL) {
        // Ensure we don't display any old images before we load a new one when scrolling by killing any possibly running image loading tasks
        image = nil
        
        // At this stage we know we should be loading an image so add the spinner
        addSpinner()
        
        // Brand new cells won't have a task to cancel, but if it's been initialised we'll want to cancel the previous
        // task to avoid repeating requests resulting in images being shown one after another
        if let task = task {
            task.cancel()
        }
        
        // If the image is in the image cache, keyed by url, then use that
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            image = imageFromCache
            removeSpinner()
            // Return here so we don't try to perform an HTTP request to get the image
            return
        }
        
        // If we don't currently have an image then request one based on the URL passed in when
        // calling this method
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Ensure we can get hold of the data and if we can't then bail. If we can, then store it
            guard
                let data = data,
                let newImage = UIImage(data: data)
            else {
                return
            }
            
            // ...so that we can cache it so we won't need to do the request the next time
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                // ...and so that we can set the image on the image view and remove the loading spinner
                self.image = newImage
                self.removeSpinner()
            }
        }
        
        // Start this task
        task.resume()
    }
    
    func addSpinner() {
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
}
