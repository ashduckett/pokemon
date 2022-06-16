//
//  PokemonVC.swift
//  Pokemon
//
//  Created by Ash Duckett on 15/06/2022.
//

import Foundation
import UIKit

class PokemonVC: UIViewController {
    var stats: PokemonStats?
    var safeArea: UILayoutGuide!
    let imageIV = CustomImageView()
    let nameLabel = UILabel()
    let statsLabel = UILabel()
    let dismissButton = UIButton()
    
    // On loading this Pokemon detail screen set the background colour, get hold of a safe area reference and call the setup methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        safeArea = view.layoutMarginsGuide
        setupImage()
        setupName()
        setupCloseButton()
        setupStatsLabel()
        setupData()
    }
    
    // Places and constrains the image onto the screen
    func setupImage() {
        view.addSubview(imageIV)
        imageIV.translatesAutoresizingMaskIntoConstraints = false
        imageIV.contentMode = .scaleAspectFit
        imageIV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageIV.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50).isActive = true
        imageIV.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.3).isActive = true
        imageIV.heightAnchor.constraint(equalTo: imageIV.widthAnchor).isActive = true
    }
    
    // Places and constrains the label underneath the name
    func setupStatsLabel() {
        view.addSubview(statsLabel)
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        statsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        statsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5).isActive = true
        statsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 5).isActive = true
        statsLabel.textColor = .white
        statsLabel.lineBreakMode = .byWordWrapping
        statsLabel.numberOfLines = 0
        statsLabel.textAlignment = .center
    }
    
    // Places and constrains the name underneath the image
    func setupName() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: imageIV.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        nameLabel.textColor = .white
    }
    
    func setupData() {
        // If we have some stats passed in...
        if let stats = stats {
            // And on those stats live a frontDefault image URL
            if let imageUrl = stats.sprites.frontDefault {
                // Use that URL to load an image which will be the centre piece of the UI
                if let url = URL(string: imageUrl) {
                    imageIV.loadImage(from: url)
                }
                
            } else {
                // If there isn't an image URL then just use the placeholder image stored locally.
                imageIV.image = UIImage(named: "placeholder")
            }
            
            // Set the name to be displayed under the image
            nameLabel.text = stats.name
            
            // Create a comma separated list of Pokemon abilities to be used later
            var statText = ""
            for (index, ability) in stats.abilities.enumerated() {
                statText += (index > 0 ? ", " : "") + "\(ability.ability.name)"
            }
                
            // Use the above abilities and species to output a bit of information on the selected Pokemon.
            statsLabel.text = "This Pokemon is a \(stats.species.name) and has the following abilities: \(statText)."
        
        }
    }
    
    // Set up and add listener to close button
    func setupCloseButton() {
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        dismissButton.setTitle("Close", for: .normal)
        dismissButton.setTitleColor(.white, for: .normal)
        
        // Ensure the VC is closed when hitting this button.
        dismissButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
    
    // Called when close button tapped, it dismisses the current VC.
    @objc func closeAction() {
        self.dismiss(animated: true)
    }
}
