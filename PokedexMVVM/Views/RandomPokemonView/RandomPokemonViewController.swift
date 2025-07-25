//
//  RandomPokemonView.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 23/06/25.
//

import UIKit

final class RandomPokemonViewController : UIViewController {
    
    private let viewModel : RandomPokemonDetailViewModel
    weak var coordinator : AppCoordinator?
    
    private lazy var randomPokemonLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Você quer descobrir novos Pokémon?"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var fetchRandomPokemonButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Capture um pokemon", for: .normal)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(randomPokemonLabel)
        view.addSubview(fetchRandomPokemonButton)
        
        NSLayoutConstraint.activate([
            
            randomPokemonLabel.bottomAnchor.constraint(equalTo: fetchRandomPokemonButton.topAnchor,constant: -10),
            
            randomPokemonLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            randomPokemonLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            fetchRandomPokemonButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchRandomPokemonButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fetchRandomPokemonButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fetchRandomPokemonButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onDisplayRandomPokemon = { [unowned self] pokemon in
            DispatchQueue.main.async {
                self.coordinator?.navigateToDetail(pokemon: pokemon)
            }
        }
    }
    
    @objc func didTapFetchRandomPokemonButton(_ sender:UIButton) {
        Task { try await viewModel.fetchRandomPokemon() }
    }
}
