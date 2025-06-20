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

class PokemonListViewViewModel_Impl: PokemonListViewViewModel {

    private(set) var pokemonList: [PokemonListResult] = []
    var displayData: (() -> Void)?
    private(set) var isLoading: Bool = false
    private var nextURL: String?

    func fetchPokemons() async throws {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await fetchInitialPokemonData()
            self.pokemonList = response.results
            self.nextURL = response.next
            displayData?()
        } catch {
            print("Fetch error: \(error)")
            throw error
        }
    }

    func loadMorePokemons() async {
        guard !isLoading, let nextURL = nextURL else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let response: APIResponse = try await NetworkManager.shared.fetchData(from: nextURL)
            self.nextURL = response.next
            self.pokemonList.append(contentsOf: response.results)
            displayData?()
        } catch {
            print("Load more error: \(error)")
        }
    }

    private func fetchInitialPokemonData() async throws -> APIResponse {
        try await NetworkManager.shared.fetchData(from: Endpoint.short.url)
    }
}

