//
//  RandomPokemonView.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 23/06/25.
//

import UIKit

class RandomPokemonViewController : UIViewController {
    
    let viewModel : RandomPokemonDetailViewModel
    weak var coordinator : AppCoordinator?
    
    private lazy var fetchRandomPokemonButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Fetch random pokemon", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapFetchRandomPokemonButton(_:)), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: RandomPokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(fetchRandomPokemonButton)
        
        NSLayoutConstraint.activate([
            fetchRandomPokemonButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchRandomPokemonButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fetchRandomPokemonButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fetchRandomPokemonButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.displayRandomPokemon = { pokemon in
            DispatchQueue.main.async { [weak self] in
                self?.coordinator?.navigateToDetail(pokemon: pokemon)
            }
        }
    }
    
    @objc func didTapFetchRandomPokemonButton(_ sender:UIButton) {
        Task { await viewModel.fetchRandomPokemon() }
    }
}
