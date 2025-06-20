//
//  PokemonCellViewModel.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/10/25.
//


struct PokemonCellViewModel {
    
    var pokemon: PokemonListResult
    
    init(pokemon: PokemonListResult) {
        self.pokemon = pokemon
        //https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/5.png
    }
    
    var id : String {
        return (String(self.pokemonURL.split(separator: "/").last ?? "0"))
    }
    
    var name: String {
        return pokemon.name.capitalized
    }
    
    var pokemonURL: String {
        return pokemon.url
    }
    
    var imageURL: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    }
    
    var number : String {
        return "#\(String(format: "%03d", Int(pokemonURL.split(separator: "/").last ?? "0") ?? 0))"
    }
}
