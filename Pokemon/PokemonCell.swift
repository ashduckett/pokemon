//
//  PokemonCell.swift
//  Pokemon
//
//  Created by Ash Duckett on 15/06/2022.
//

import Foundation
import UIKit

// This class represents a custom UITableViewCell
class PokemonCell: UITableViewCell {
    var safeArea: UILayoutGuide!
    let imageIV = CustomImageView()
    let nameLabel = UILabel()
    
    // Run initialiser and set up view
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    // Necessary
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setupView() {
        // Get a reference to layoutMarginsGuide so they can be used with constraints later
        safeArea = layoutMarginsGuide
        
        // Set up the main image view
        setupImageView()
        
        // Set up the name label shown under the image
        setupNameLabel()
    }
    
    // This function adds the custom image view to the VC and constrains it.
    func setupImageView() {
        addSubview(imageIV)
        imageIV.translatesAutoresizingMaskIntoConstraints = false
        imageIV.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        imageIV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageIV.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageIV.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    // This function adds the name label which is to the right of the image added above
    func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: imageIV.trailingAnchor, constant: 5).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    }
    
}
