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
    
    func setupImage() {
        view.addSubview(imageIV)
        imageIV.translatesAutoresizingMaskIntoConstraints = false
        imageIV.contentMode = .scaleAspectFit
        imageIV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageIV.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50).isActive = true
        imageIV.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.3).isActive = true
        imageIV.heightAnchor.constraint(equalTo: imageIV.heightAnchor).isActive = true
    }
    
    func setupStatsLabel() {
        view.addSubview(statsLabel)
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
//        statsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        statsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        statsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5).isActive = true
        statsLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 5).isActive = true
        statsLabel.textColor = .white
        statsLabel.lineBreakMode = .byWordWrapping
        statsLabel.numberOfLines = 0
//        statsLabel.adjustsFontSizeToFitWidth = true
        statsLabel.textAlignment = .center
    }
    
    func setupName() {
        view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: imageIV.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        nameLabel.textColor = .white
    }
    
    func setupData() {
        if let stats = stats, let url = URL(string: stats.sprites.frontDefault) {
            imageIV.loadImage(from: url)
            nameLabel.text = stats.name
            var statText = ""
            
            for (index, ability) in stats.abilities.enumerated() {
                statText += (index > 0 ? ", " : "") + "\(ability.ability.name)"
            }
                
                
            
            statsLabel.text = "This Pokemon is a \(stats.species.name) and has the following abilities: \(statText)."
        }
    }
    
    func setupCloseButton() {
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        dismissButton.setTitle("Close", for: .normal)
        dismissButton.setTitleColor(.white, for: .normal)
        
        dismissButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true)
    }
}
