//
//  PokemonAPI.swift
//  Pokemon
//
//  Created by Ash Duckett on 15/06/2022.
//

import Foundation

class PokemonAPI {
    static let shared = PokemonAPI()
    
    func fetchPokemon(onCompletion: @escaping ([Pokemon]) -> ()) {
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
            onCompletion(pokemonList.results)
        }
        task.resume()
    }
    
    func fetchPokemonStats(urlString: String, onCompletion: @escaping (PokemonStats) -> ()) {
        let url = URL(string: urlString)!
        print(url)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Could not get data when fetching Pokemon Stats")
                return
            }
            
            guard let pokemonStats = try? JSONDecoder().decode(PokemonStats.self, from: data) else {
                print("Could not decode Pokemon Stats JSON")
                return
            }
            
            print(pokemonStats)
            onCompletion(pokemonStats)
        }
        task.resume()
    }
}

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
    let frontDefault: String
    
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
