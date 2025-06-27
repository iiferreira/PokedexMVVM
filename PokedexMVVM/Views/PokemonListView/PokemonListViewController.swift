//
//  PokemonListViewController.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/10/25.
//

import UIKit

final class PokemonListViewController : UIViewController {
    
    let pokemonListView = PokemonListView()
    var viewModel : PokemonListViewViewModel
    var coordinator : AppCoordinator?
    
    override func loadView() {
        self.view = pokemonListView
    }
    
    init(pokemonListViewViewModel: PokemonListViewViewModel) {
        self.viewModel = pokemonListViewViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPokemons()
        setupTableView()
        bindViewModel()
        self.title = "Pokemon"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    private func bindViewModel() {
        viewModel.displayData = { [weak self] in
            DispatchQueue.main.async {
                self?.pokemonListView.displayPokemons()
            }
        }
    }
    
    private func setupTableView() {
        pokemonListView.tableView.delegate = self
        pokemonListView.tableView.dataSource = self
    }
    
    private func fetchPokemons() {
        Task(priority: .userInitiated) { try await viewModel.fetchPokemons() }
    }
}

