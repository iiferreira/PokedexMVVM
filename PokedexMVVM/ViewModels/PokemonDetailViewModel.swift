//
//  PokemonDetailViewModel.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/12/25.
//

final class PokemonDetailViewModel {
    
    private let pokemon: PokemonListResult
    private(set) var isFavorite: Bool = false

    typealias PokemonDetailHandler = (Pokemon, PokemonColor) -> Void
    var onPokemonDetailFetched: PokemonDetailHandler?
    
    init(pokemon: PokemonListResult) {
        self.pokemon = pokemon
    }
    
    func checkFavoriteStatus() {
        guard let id = pokemon.id else { return }
        isFavorite = CoreDataManager.shared.checkIfFavoritePokemonExists(id)
    }
    
    func fetchPokemonDetail() async {
        guard let id = pokemon.id else { return }

        if let cachedDetail = PokemonCache.shared.pokemonDetails[id] {
            if let cachedColor = PokemonCache.shared.pokemonColors[id] {
                onPokemonDetailFetched?(cachedDetail, cachedColor)
                return
            }
        }

        do {
            let detail: Pokemon = try await NetworkManager.shared.fetchData(from: pokemon.url)
            let color = try await fetchPokemonColor()

            PokemonCache.shared.saveDetail(detail, for: id)
            PokemonCache.shared.saveColor(color, for: id)

            onPokemonDetailFetched?(detail, color)
        } catch {
            print("Failed to fetch Pokémon detail: \(error)")
            // Optional: Retry logic or error callback here
        }
    }
    
    func toggleFavoriteStatus() {
        guard let id = pokemon.id else { return }

        if isFavorite {
            CoreDataManager.shared.removeFromFavorites(id)
        } else {
            CoreDataManager.shared.saveFavoritePokemon(pokemon)
        }

        isFavorite.toggle()
    }
    
    private func fetchPokemonColor() async throws -> PokemonColor {
        let url = Endpoint.colorForPokemonID(pokemon.id ?? 0).url
        return try await NetworkManager.shared.fetchData(from: url)
    }
}

