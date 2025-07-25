
//
//  PokemonListViewViewModel.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/10/25.
//

import UIKit

import Foundation
import UIKit


protocol PokemonListViewViewModel {
    var pokemonList: [PokemonListResult] { get }
    var displayData: (() -> Void)? { get set }
    var isLoading: Bool { get }

    func fetchPokemons() async throws
    func loadMorePokemons() async throws
}

// MARK: - ViewModel Implementation
final class PokemonListViewViewModelImpl: PokemonListViewViewModel {

    private(set) var pokemonList: [PokemonListResult] = []
    var displayData: (() -> Void)?
    private(set) var isLoading: Bool = false

    private var nextURL: String?
    private var service: PokemonServiceProtocol

    init(service: PokemonServiceProtocol = PokemonService()) {
        self.service = service
    }

    func setService(_ service: PokemonServiceProtocol) {
        self.service = service
    }

    func fetchPokemons() async throws {
        guard canStartLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.fetchInitialPokemons()
            pokemonList = response.results
            nextURL = response.next
            displayData?()
        } catch {
            throw error
        }
    }

    func loadMorePokemons() async throws {
        guard canStartLoading, let url = nextURL else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.fetchMorePokemons(from: url)
            pokemonList.append(contentsOf: response.results)
            nextURL = response.next
            displayData?()
        } catch {
            throw error
        }
    }

    private var canStartLoading: Bool {
        !isLoading
    }
}
