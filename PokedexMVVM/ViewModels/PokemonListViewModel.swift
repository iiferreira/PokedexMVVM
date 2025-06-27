//
//  PokemonListViewViewModel.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/10/25.
//

import UIKit

protocol PokemonListViewViewModel {
    var pokemonList: [PokemonListResult] { get }
    var displayData: (() -> Void)? { get set }
    var isLoading: Bool { get }

    func fetchPokemons() async throws
    func loadMorePokemons() async
}


final class PokemonListViewViewModelImpl: PokemonListViewViewModel {

    private(set) var pokemonList: [PokemonListResult] = []
    var displayData: (() -> Void)?
    private(set) var isLoading: Bool = false
    private var nextURL: String?

    func fetchPokemons() async throws {
        guard canStartLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await fetchInitialPokemonData()
            pokemonList = response.results
            nextURL = response.next
            displayData?()
        } catch {
            print("Failed to fetch Pokémons: \(error)")
            throw error
        }
    }

    func loadMorePokemons() async {
        guard canStartLoading, let url = nextURL else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let response: APIResponse = try await NetworkManager.shared.fetchData(from: url)
            nextURL = response.next
            pokemonList.append(contentsOf: response.results)
            displayData?()
        } catch {
            print("Failed to load more Pokémons: \(error)")
        }
    }

    private var canStartLoading: Bool {
        !isLoading
    }

    private func fetchInitialPokemonData() async throws -> APIResponse {
        try await NetworkManager.shared.fetchData(from: Endpoint.short.url)
    }
}
