//
//  PokemonListViewController+UITableView.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/10/25.
//

import UIKit

extension PokemonListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonList.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = viewModel.pokemonList[indexPath.row]
        coordinator?.navigateToDetail(pokemon:pokemon)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == viewModel.pokemonList.count {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "BlankCell")
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PokemonTableViewCell.cellIdentifier,
            for: indexPath
        ) as? PokemonTableViewCell else {
            return UITableViewCell()
        }

        let pokemon = viewModel.pokemonList[indexPath.row]
        cell.configure(with: PokemonCellViewModel(pokemon: pokemon))
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        guard contentHeight > height else { return }
        
        if offsetY > contentHeight - height - 100 {
            Task { try await viewModel.loadMorePokemons() }
        }
    }

}
