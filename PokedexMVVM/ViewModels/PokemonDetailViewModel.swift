//
//  PokemonDetailViewModel.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/12/25.
//

protocol PokemonDetail_Protocol {
    typealias PokemonData = ((Pokemon),(PokemonColor))->(Void)?
    var displayPokemonDetail : PokemonData? { get set }
    var isFavorite : Bool { get set }
    func checkFavoriteStatus()
    func fetchPokemonDetail() async throws
    func fetchPokemonColor() async throws -> PokemonColor
    func favoritePokemon()
}

class PokemonDetailViewModel : PokemonDetail_Protocol {
    
    private var pokemon : PokemonListResult
    var isFavorite : Bool = false
    
    typealias PokemonData = ((Pokemon),(PokemonColor))->(Void)?
    
    var displayPokemonDetail : PokemonData?
    
    init (pokemon: PokemonListResult) {
        self.pokemon = pokemon
    }
    
    func checkFavoriteStatus() {
        isFavorite = CoreDataManager.shared.checkIfFavoritePokemonExists(pokemon.id ?? 0)
    }
    
    func fetchPokemonDetail() async throws {
        guard let pokemonID = pokemon.id else { return }
        if let cached = PokemonCache.shared.pokemonDetails[pokemonID] {
            self.displayPokemonDetail?(cached,try await fetchPokemonColor())
        }
        let pokemonDetail : Pokemon = try await NetworkManager.shared.fetchData(from: pokemon.url)
        let pokemonColor = try await fetchPokemonColor()
        PokemonCache.shared.saveDetail(pokemonDetail, for: pokemonID)
        PokemonCache.shared.saveColor(pokemonColor, for: pokemonID)
        self.displayPokemonDetail?(pokemonDetail,pokemonColor)
    }
    
    func fetchPokemonColor() async throws -> PokemonColor {
        let url = Endpoint.colorForPokemonID(pokemon.id ?? 0).url
        let pokemonColor : PokemonColor = try await NetworkManager.shared.fetchData(from: url)
        return pokemonColor
    }
    
    func favoritePokemon() {
        guard let id = pokemon.id else { return }
        
        if CoreDataManager.shared.checkIfFavoritePokemonExists(id) {
            CoreDataManager.shared.removeFromFavorites(id)
            isFavorite.toggle()
        } else {
            CoreDataManager.shared.saveFavoritePokemon(pokemon)
            isFavorite.toggle()
        }
    }
}
