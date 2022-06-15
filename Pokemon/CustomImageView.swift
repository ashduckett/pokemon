//
//  CustomImageView.swift
//  Pokemon
//
//  Created by Ash Duckett on 15/06/2022.
//

import UIKit

class CustomImageView: UIImageView {
    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let newImage = UIImage(data: data)
            else {
                print("Could not load image from url: \(url)")
                return
            }
        
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}
