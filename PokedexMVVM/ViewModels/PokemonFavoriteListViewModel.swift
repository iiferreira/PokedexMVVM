//
//  PokemonFavoriteListViewModel.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/13/25.
//

import Foundation

final class PokemonFavoriteListViewModel {
    
    private(set) var favoritePokemons: [PokemonListResult] = []
    var updateFavoritePokemons: (() -> Void)?
    var displayNoFavoritePokemons: (() -> Void)?
    
    init() {}
    
    func getFavoritePokemons() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let favorites = CoreDataManager.shared.fetchPokemons()
            
            var newFavorites: [PokemonListResult] = []
            favorites.forEach {
                newFavorites.append(PokemonListResult(name: $0.name ?? "", url: $0.url ?? ""))
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.favoritePokemons = newFavorites
                if self.favoritePokemons.isEmpty {
                    self.displayNoFavoritePokemons?()
                    return 
                }
                self.updateFavoritePokemons?()
            }
        }
    }
}
