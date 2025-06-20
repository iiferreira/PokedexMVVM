//
//  Constants.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/12/25.
//

enum Endpoint  {
    case full
    case short
    case pokemon(Int)
    case colorForPokemonID(Int)
    
    var url: String {
        switch self {
        case .full:
            return "https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0"
        case .short:
            return "https://pokeapi.co/api/v2/pokemon"
        case .pokemon(let id):
            return "https://pokeapi.co/api/v2/pokemon/\(id)"
        case .colorForPokemonID(let id):
            return "https://pokeapi.co/api/v2/pokemon-species/\(id)/"
        }
    }
}
