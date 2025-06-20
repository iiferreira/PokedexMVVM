//
//  PokemonColor.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/13/25.
//


struct PokemonColor : Decodable {
    let color : Color
}

struct Color : Decodable {
    let name : String
}
