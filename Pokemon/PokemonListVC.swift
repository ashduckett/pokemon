//
//  ViewController.swift
//  Pokemon
//
//  Created by Ash Duckett on 15/06/2022.
//

import UIKit

class PokemonListVC: UIViewController {
    var safeArea: UILayoutGuide!
    let searchBar = UISearchBar()
    let tableView = UITableView()
    var pokemonList = [Pokemon]()
    
    override func viewDidLoad() {
        // This doesn't appear to work. Why not?
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        setupView()
        
        let anonymousFunction = { (fetchedPokemonList: [Pokemon]) in
            DispatchQueue.main.async {
                self.pokemonList = fetchedPokemonList
                self.tableView.reloadData()
            }
            
            
        }
        
        PokemonAPI.shared.fetchPokemon(onCompletion: anonymousFunction)
    }
    
    // MARK: - Setup View
    func setupView() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
     
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .white
        
    }
}

// MARK: - UITableViewDataSource
extension PokemonListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        let pokemon = pokemonList[indexPath.row]
        
        cell.textLabel?.text = pokemon.name
        return cell
    }
    
    
    
}

