
//
//  MockPokemonService.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 7/25/25.
//


import Foundation
@testable import PokedexMVVM

final class MockPokemonService: PokemonServiceProtocol {

    enum MockMode {
        case successInitial
        case successMore
        case failure
    }

    var mode: MockMode

    init(mode: MockMode) {
        self.mode = mode
    }

    func fetchInitialPokemons() async throws -> APIResponse {
        switch mode {
        case .successInitial:
            return APIResponse(
                next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20", count: 2,
                results: [
                    PokemonListResult(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                    PokemonListResult(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/")
                ]
            )
        case .failure:
            throw URLError(.notConnectedToInternet)
        default:
            fatalError("fetchInitialPokemons called in wrong mock mode")
        }
    }

    func fetchMorePokemons(from url: String) async throws -> APIResponse {
        switch mode {
        case .successMore:
            return APIResponse(
                next: nil, count: 2,
                results: [
                    PokemonListResult(name: "squirtle", url: "https://pokeapi.co/api/v2/pokemon/7/"),
                    PokemonListResult(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")
                ]
            )
        case .failure:
            throw URLError(.badServerResponse)
        default:
            fatalError("fetchMorePokemons called in wrong mock mode")
        }
    }
}
