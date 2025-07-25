//
//  PokemonFavoriteViewController.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 03/06/25.
//

import UIKit

final class PokemonFavoriteViewController : UIViewController {
    
    private var viewModel : PokemonFavoriteListViewModel
    weak var coordinator : AppCoordinator?
    
    private lazy var emptyView = EmptyPokemonView()
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.cellIdentifier)
        return tableView
    }()
    
    init(viewModel : PokemonFavoriteListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.getFavoritePokemons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.widthAnchor.constraint(equalToConstant: 300),
            emptyView.heightAnchor.constraint(equalToConstant: 300),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.updateFavoritePokemons = { [weak self] in
            self?.emptyView.isHidden = true
            self?.tableView.reloadData()
        }
        
        viewModel.displayNoFavoritePokemons = { [weak self] in
            self?.tableView.reloadData()
            self?.emptyView.isHidden = false
        }
    }
}

extension PokemonFavoriteViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoritePokemons.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.navigateToDetail(pokemon: viewModel.favoritePokemons[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.cellIdentifier, for: indexPath) as? PokemonTableViewCell else { return UITableViewCell()}
        
        let pokemonCellViewModel = PokemonCellViewModel(pokemon: viewModel.favoritePokemons[indexPath.row])
        
        cell.configure(with: pokemonCellViewModel)
        return cell
    }
}
