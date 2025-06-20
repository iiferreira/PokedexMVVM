//
//  Coordinator.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/10/25.
//

import UIKit

protocol Coordinator {
    var navController : UINavigationController { get set }
    func start()
    func navigateToDetail(pokemon: PokemonListResult)
}
