//
//  CoreDataManager.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/13/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteDataModel")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func saveFavoritePokemon(_ pokemon: PokemonListResult) {
        guard let id = pokemon.id else { return }
        let context = persistentContainer.viewContext
        let favorite = FavoritePokemon(context: context)
        favorite.name = pokemon.name
        favorite.url = pokemon.url
        favorite.id = Int16(id)
        saveContext()
    }
    
    func checkIfFavoritePokemonExists(_ pokemonId: Int) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", pokemonId)
        do {
            let favoritePokemons = try context.fetch(fetchRequest)
            return !favoritePokemons.isEmpty
        } catch {
            print("Error")
            return false
        }
    }
    
    func fetchPokemons() -> [FavoritePokemon] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
        do {
            let favoritePokemons = try context.fetch(fetchRequest)
            return favoritePokemons
        } catch {
            print("Error fetching pokemons: \(error)")
        }
        return [FavoritePokemon]()
    }
    
    func removeFromFavorites(_ pokemonId: Int) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", pokemonId)
        do {
            let favoritePokemons = try context.fetch(fetchRequest)
            if let pokemonToDelete = favoritePokemons.first {
                context.delete(pokemonToDelete)
                saveContext()
            }
        } catch {
            print("Error deletando pokemon: \(error)")
        }
    }
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
