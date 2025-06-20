//
//  PokemonFavoriteListViewModel.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/13/25.
//

import Foundation

class PokemonFavoriteListViewModel {
    
    private(set) var favoritePokemons: [PokemonListResult] = []
    var updateFavoritePokemons: (() -> Void)?
    
    init() {}
    
    func getFavoritePokemons() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let favorites = CoreDataManager.shared.fetchPokemons()
            
            var newFavorites: [PokemonListResult] = []
            favorites.forEach {
                newFavorites.append(PokemonListResult(name: $0.name ?? "", url: $0.url ?? ""))
            }
            
            DispatchQueue.main.async {
                self.favoritePokemons = newFavorites
                if self.favoritePokemons.isEmpty {
                    print("No favorite")
                }
                self.updateFavoritePokemons?()
            }
        }
    }
}
