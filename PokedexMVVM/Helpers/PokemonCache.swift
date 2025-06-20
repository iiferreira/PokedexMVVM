//
//  PokemonCache.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/13/25.
//


class PokemonCache {
    static let shared = PokemonCache()

    private(set) var pokemonDetails: [Int: Pokemon] = [:]
    private(set) var pokemonColors: [Int: PokemonColor] = [:]

    private init() {}

    func getDetail(for id: Int) -> Pokemon? {
        return pokemonDetails[id]
    }

    func saveDetail(_ pokemon: Pokemon, for id: Int) {
        pokemonDetails[id] = pokemon
    }

    func getColor(for id: Int) -> PokemonColor? {
        return pokemonColors[id]
    }

    func saveColor(_ color: PokemonColor, for id: Int) {
        pokemonColors[id] = color
    }
}
