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
        // Ensure we don't display any old images before we load a new one when scrolling
        image = nil
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
        
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let newImage = UIImage(data: data)
            else {
                print("Could not load image from url: \(url)")
                return
            }
        
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = newImage
                self.removeSpinner()
            }
        }
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
