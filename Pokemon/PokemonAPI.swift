//
//  PokemonAPI.swift
//  Pokemon
//
//  Created by Ash Duckett on 15/06/2022.
//

import Foundation

class PokemonAPI {
    static let shared = PokemonAPI()
    
    func fetchPokemon() {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=1126"
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Could not get data when fetching Pokemon")
                return
            }
            
            guard let pokemonList = try? JSONDecoder().decode(PokemonList.self, from: data) else {
                print("Could not decode Pokemon JSON")
                return
            }
            
            print(pokemonList)
        }
        task.resume()
    }
}

struct PokemonList: Codable {
    let results: [Pokemon]
    let count: Int
}

struct Pokemon: Codable {
    let name: String
    let url: String
}
