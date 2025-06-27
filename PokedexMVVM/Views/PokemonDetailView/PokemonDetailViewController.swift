//
//  PokemonDetailViewController.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/12/25.
//

import Foundation
import UIKit

final class PokemonDetailViewController: UIViewController {

    private let pokemonView: PokemonDetailView
    private let viewModel: PokemonDetailViewModel

    private var currentChildVC: UIViewController?
    private var detailVC: PokemonDetailInfoViewController?
    private var statsVC: PokemonDetailStatsViewController?

    init(view: PokemonDetailView, viewModel: PokemonDetailViewModel) {
        self.pokemonView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = pokemonView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        fetchData()
    }

    private func setupView() {
        pokemonView.delegate = self
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: viewModel.isFavorite ? "heart.fill" : "heart"),
            style: .plain,
            target: self,
            action: #selector(didTapFavoriteButton)
        )
    }

    private func fetchData() {
        Task(priority: .userInitiated) {
            await viewModel.fetchPokemonDetail()
        }
        viewModel.checkFavoriteStatus()
    }

    private func bindViewModel() {
        viewModel.onPokemonDetailFetched = { [weak self] pokemon, colorInfo in
            guard let self = self else { return }
            guard let backgroundColor = self.convertReturnedColorToBackGroundColor(color: colorInfo.color.name) else { return }

            DispatchQueue.main.async {
                self.configureUI(with: pokemon, backgroundColor: backgroundColor)
            }
        }

        viewModel.displayError = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlertError()
            }
        }
    }

    private func configureUI(with pokemon: Pokemon, backgroundColor: UIColor) {
        pokemonView.configureWith(pokemon: pokemon, color: backgroundColor)

        detailVC = PokemonDetailInfoViewController(pokemon: pokemon)
        statsVC = PokemonDetailStatsViewController(pokemon: pokemon, color: backgroundColor)

        if let detailVC = detailVC {
            switchToChild(detailVC)
        }
    }

    @objc private func didTapFavoriteButton() {
        viewModel.toggleFavoriteStatus()
        let imageName = viewModel.isFavorite ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
    }

    private func showAlertError() {
        let alert = UIAlertController(
            title: "Error",
            message: "Error fetching Pokémon.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

extension PokemonDetailViewController: PokemonDetailViewDelegate {
    func didTapSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: if let detailVC = detailVC { switchToChild(detailVC) }
        case 1: if let statsVC = statsVC { switchToChild(statsVC) }
        default: break
        }
    }
}


private extension PokemonDetailViewController {
    func switchToChild(_ newVC: UIViewController) {
        let container = pokemonView.containerView

        if let current = currentChildVC {
            current.willMove(toParent: nil)
            addChild(newVC)

            UIView.transition(from: current.view,
                              to: newVC.view,
                              duration: 0.3,
                              options: [.transitionCrossDissolve, .showHideTransitionViews]) { [weak self] _ in
                guard let self else { return }

                current.view.removeFromSuperview()
                current.removeFromParent()

                self.attachChild(newVC, to: container)
                self.currentChildVC = newVC
            }

        } else {
            addChild(newVC)
            attachChild(newVC, to: container)
            currentChildVC = newVC
        }
    }

    func attachChild(_ child: UIViewController, to container: UIView) {
        container.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: pokemonView.segmentedControl.bottomAnchor, constant: 16),
            child.view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            child.view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            child.view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24)
        ])
        child.didMove(toParent: self)
    }
}
