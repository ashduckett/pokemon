//
//  PokemonAPI.swift
//  Pokemon
//
//  Created by Ash Duckett on 15/06/2022.
//

import Foundation

class PokemonAPI {
    // Use as a singleton instance so these functions can just be called without creating an instance of PokemonAPI
    static let shared = PokemonAPI()
    
    // A function to load all Pokemon, the initial HTTP request
    func fetchPokemon(onCompletion: @escaping ([Pokemon]) -> ()) {
        // I'm making the assumption that the number of Pokemon won't grow so limit is set to the total number
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=1126"
        
        // Then an actual URL object is created, force unwrapping because the URL is immediately above
        let url = URL(string: urlString)!
        
        // Then a task is set up to hit the above URL.
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // If we couldn't get data, then return because we can't do anything
            guard let data = data else {
                print("Could not get data when fetching Pokemon")
                return
            }
            
            // Decode the list of Pokemon based on the PokemonList type, again, if that can't be done then just
            // bail
            guard let pokemonList = try? JSONDecoder().decode(PokemonList.self, from: data) else {
                print("Could not decode Pokemon JSON")
                return
            }
            
            // Once we have our data, pass it back into the function passed in, giving the outside world access
            onCompletion(pokemonList.results)
        }
        // Start this asynchronous task
        task.resume()
    }
    
    // A funciton used to get hold of the stats of a specific Pokemon based on the URL passed in
    func fetchPokemonStats(urlString: String, onCompletion: @escaping (PokemonStats) -> ()) {
        // Construct an actual URL object based on the string passed in. Force unwrapped because the URL should always exist.
        let url = URL(string: urlString)!
        
        // Create a task hitting that URL
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // If we couldn't get any data then bail out because we can't get the stats
            guard let data = data else {
                print("Could not get data when fetching Pokemon Stats")
                return
            }
            
            // If we could get the data then attempt to decode it into a PokemonStats instance based on the data,
            // otherwise bail
            guard let pokemonStats = try? JSONDecoder().decode(PokemonStats.self, from: data) else {
                print("Could not decode Pokemon Stats JSON")
                return
            }
            
            // Pass the built up data to the outside world
            onCompletion(pokemonStats)
        }
        task.resume()
    }
}

// Structs used to represent the received data from API calls
struct PokemonStats: Codable {
    let name: String
    let height: Int
    let abilities: [PokemonAbility]
    let species: Species
    let sprites: Sprites
}

struct Species: Codable {
    let name: String
}

struct Sprites: Codable {
    let frontDefault: String?
    
    private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonAbility: Codable {
    let ability: BasePokemonAbility
}

struct BasePokemonAbility: Codable {
    let name: String
}

struct PokemonList: Codable {
    let results: [Pokemon]
    let count: Int
}

struct Pokemon: Codable {
    let name: String
    let url: String
}
