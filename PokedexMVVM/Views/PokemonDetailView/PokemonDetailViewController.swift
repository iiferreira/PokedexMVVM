//
//  PokemonDetailViewController.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/12/25.
//

import Foundation
import UIKit

class PokemonDetailViewController : UIViewController {
    
    var currentChildVC: UIViewController?
    
    let pokemonView : PokemonDetailView
    var viewModel: PokemonDetailViewModel
    
    var detailVC: PokemonDetailInfoViewController?
    var statsVC : PokemonDetailStatsViewController?

    init(view:PokemonDetailView ,viewModel:PokemonDetailViewModel) {
        self.viewModel = viewModel
        self.pokemonView = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = pokemonView
    }
    
    override func viewDidLoad() {
        pokemonView.delegate = self
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await viewModel.fetchPokemonDetail() }
        viewModel.checkFavoriteStatus()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: viewModel.isFavorite ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(didTapFavoriteButton))
    }
    
    func bindViewModel() {
        viewModel.onPokemonDetailFetched = { [weak self] pokemon,pokemonColor in
            guard let color = self?.convertReturnedColorToBackGroundColor(color: pokemonColor.color.name) else { return }
            
            DispatchQueue.main.async {
                self?.pokemonView.configureWith(pokemon: pokemon,color:color)
                self?.detailVC = PokemonDetailInfoViewController(pokemon: pokemon)
                self?.statsVC = PokemonDetailStatsViewController(pokemon: pokemon, color: color)
                
                if let detailVC = self?.detailVC {
                    self?.switchToChild(detailVC)
                }
            }
        }
    }
    
    @objc func didTapFavoriteButton() {
        viewModel.toggleFavoriteStatus()
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
    }
}

extension PokemonDetailViewController : PokemonDetailViewDelegate {
    func didTapSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            if let detailVC {
                switchToChild(detailVC)
            }
        case 1:
            if let statsVC {
                switchToChild(statsVC)
            }
        default:
            break
        }
    }
}


extension PokemonDetailViewController {
    func switchToChild(_ newVC: UIViewController) {
        if let current = currentChildVC {
            current.willMove(toParent: nil)
            
            UIView.transition(from: current.view,
                              to: newVC.view,
                              duration: 0.3,
                              options: [.transitionCrossDissolve, .showHideTransitionViews]) {
                [weak self] _ in
                guard let self = self else { return }
                
                current.view.removeFromSuperview()
                current.removeFromParent()
                
                self.addChild(newVC)
                pokemonView.containerView.addSubview(newVC.view)
                newVC.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    newVC.view.topAnchor.constraint(equalTo: pokemonView.segmentedControl.bottomAnchor, constant: 16),
                    newVC.view.leadingAnchor.constraint(equalTo: pokemonView.containerView.leadingAnchor, constant: 8),
                    newVC.view.trailingAnchor.constraint(equalTo: pokemonView.containerView.trailingAnchor, constant: -8),
                    newVC.view.bottomAnchor.constraint(equalTo: pokemonView.containerView.bottomAnchor, constant: -24)
                ])
                newVC.didMove(toParent: self)
                self.currentChildVC = newVC
            }
        } else {
            addChild(newVC)
            pokemonView.containerView.addSubview(newVC.view)
            newVC.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newVC.view.topAnchor.constraint(equalTo: pokemonView.segmentedControl.bottomAnchor, constant: 16),
                newVC.view.leadingAnchor.constraint(equalTo: pokemonView.containerView.leadingAnchor, constant: 8),
                newVC.view.trailingAnchor.constraint(equalTo: pokemonView.containerView.trailingAnchor, constant: -8),
                newVC.view.bottomAnchor.constraint(equalTo: pokemonView.containerView.bottomAnchor, constant: -24)
            ])
            newVC.didMove(toParent: self)
            currentChildVC = newVC
        }
    }
}
