//
//  AppCoordinator.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/10/25.
//

import UIKit

class AppCoordinator : Coordinator {
    var navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func start() {
        let pokemonListViewViewModel = PokemonListViewViewModelImpl()
        let pokemonListVC = PokemonListViewController(pokemonListViewViewModel: pokemonListViewViewModel)
        pokemonListVC.title = "Pokemon"
        pokemonListVC.coordinator = self
        pokemonListVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let favoriteViewModel = PokemonFavoriteListViewModel()
        let favoriteVC = PokemonFavoriteViewController(viewModel: favoriteViewModel)
        favoriteVC.coordinator = self
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 1)
        
        let randomPokemonViewModel = RandomPokemonDetailViewModel()
        let randomPokemonDetailVC = RandomPokemonViewController(viewModel: randomPokemonViewModel)
        randomPokemonDetailVC.coordinator = self
        randomPokemonDetailVC.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "dice"), tag: 2)
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([pokemonListVC,favoriteVC,randomPokemonDetailVC], animated: true)
        navController.setViewControllers([tabBarController], animated: true)
    }
    
    func navigateToDetail(pokemon: PokemonListResult) {
        let pokemonDetailView = PokemonDetailView()
        let viewModel = PokemonDetailViewModel(pokemon: pokemon)
        let detailVC = PokemonDetailViewController(view: pokemonDetailView,viewModel: viewModel)
        navController.pushViewController(detailVC, animated: true)
    }
}
