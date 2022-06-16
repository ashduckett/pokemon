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
    var filteredPokemon = [Pokemon]()
    
    override func viewDidLoad() {

        // Better than the default black to work on
        view.backgroundColor = .white
        
        // Get a reference to the safe area so we can later constrain to it
        safeArea = view.layoutMarginsGuide
        
        // Set up delegates and data sources
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // Register the PokemonCell custom UITableViewCell with an id so it can be dequeued later in the table
        tableView.register(PokemonCell.self, forCellReuseIdentifier: "cellid")
        
        // Set up the view, putting into it the table and the search bar.
        setupView()
        
        // Grab the Pokemon list from the API and then...
        let anonymousFunction = { (fetchedPokemonList: [Pokemon]) in
            DispatchQueue.main.async {
                // Store some base data which won't change during execution. This way filtered Pokemon can filter this list.
                self.pokemonList = fetchedPokemonList
                
                // Copy the full list since we're at the start of execution and we want it in full.
                self.filteredPokemon = self.pokemonList
                
                // Load the filtered Pokemon into the table
                self.tableView.reloadData()
            }
        }
        
        // Set up a tap event for the keyboard to disappear if typing but you tap on the table behind the keyboard to close it.
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Do the initial data load
        PokemonAPI.shared.fetchPokemon(onCompletion: anonymousFunction)
    }
    
    // MARK: - Setup View
    
    // This function sets up the search bar at the top of the screen and the Pokemon table underneath it.
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
    
    // Kill the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource
extension PokemonListVC: UITableViewDataSource {
    // Return the number of rows in the currently filtered results
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemon.count
    }
    
    // Generate a Pokemon cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue a cell of the PokemonCell variety, as registered in viewDidLoad
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        
        // Grab a pokemon for this cell based on the row iOS is asking for
        let pokemon = filteredPokemon[indexPath.row]
        
        // Attempt to cast cell into a PokemonCell subclass since dequeueReusableCell returns an instance of UITableViewCell
        // This means we're storing an instance of PokemonCell in this instance with this type so it needs to be cast.
        // If that doesn't work, which it will, just return an instance of UITableViewCell
        guard let pokemonCell = cell as? PokemonCell else {
            return cell
        }
        
        // Set the name to display on the cell
        pokemonCell.nameLabel.text = pokemon.name

        // Get the stats for the current pokemon cell
        let anonymousFunction = { (fetchedPokemonStats: PokemonStats) in
            // Do this asynchromously to avoid slowdown
            DispatchQueue.main.async {
                // Ensure we actually received an image URL from the received stats
                if let fetchedImageUrl = fetchedPokemonStats.sprites.frontDefault {
                    // If we did, use them
                    pokemonCell.imageIV.loadImage(from: URL(string: fetchedImageUrl)!)
                } else {
                    // If there wasn't one use a placeholder image
                    pokemonCell.imageIV.image = UIImage(named: "placeholder")
                }
                
            }
        }

        // Load the image URLs for our pokemon asynchronously
        PokemonAPI.shared.fetchPokemonStats(urlString: filteredPokemon[indexPath.row].url, onCompletion: anonymousFunction)

        // And of course return the cell
        return cell
    }
}
// MARK: - UITableViewDelegate
extension PokemonListVC: UITableViewDelegate {
    // Fired when the user taps on a row of the table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        // Fetch the stats so that they can be presented in the PokemonVC view controller
        let anonymousFunction = { (fetchedPokemonStats: PokemonStats) in
            DispatchQueue.main.async {
                // Create a new PokemonVC
                let pokemonDetailVC = PokemonVC()
                
                // Pass along the received stats
                pokemonDetailVC.stats = fetchedPokemonStats
                
                // Ensure the VC goes full screen, personally I think it looks better
                pokemonDetailVC.modalPresentationStyle = .fullScreen
                
                // Show the VC
                self.present(pokemonDetailVC, animated: true)
            }
        }
        
        // Get hold of the stats, then fire the above function on completion which will display a detail VC
        PokemonAPI.shared.fetchPokemonStats(urlString: filteredPokemon[indexPath.row].url, onCompletion: anonymousFunction)
    }
}

// MARK: - UISearchBarDelegate
extension PokemonListVC: UISearchBarDelegate {
    // Fired when the user types into the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // We have a full list of pokemon in pokemonList from which to filter.
        // Here we set filteredPokemon to:
        //   * If the searchText is empty, then we just return all of the Pokemon by accessing the untouched pokemonList
        //   * Otherwise we call the declarative array function filter. Each item iterated over for this will be a Pokemon instance
        //     and for each iteration we return true if the current Pokemon should be in the returned list and false otherwise.
        //     To get to this Boolean we perform a case insensitive search on the entered text to see if the current item's name can be
        //     found in the search text and if it can, then the returned value won't be nil, if it can't it will be nil, giving us our Boolean
        filteredPokemon = searchText.isEmpty ? pokemonList : pokemonList.filter { (item: Pokemon) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        // Once filtered, reload the table based on the newly filtered Pokemon list
        tableView.reloadData()
    }
}
