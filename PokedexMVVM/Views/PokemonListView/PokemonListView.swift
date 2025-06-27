//
//  PokemonView.swift
//  PokedexCleanSwift
//
//  Created by Iuri Ferreira on 5/26/25.
//

import Foundation
import UIKit

protocol PokemonViewDelegate: AnyObject {
    func updateTableView()
}

class PokemonListView : UIView {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var activityView : UIActivityIndicatorView =  {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    private(set) lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.cellIdentifier)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.activityView.isHidden = true
        self.activityView.startAnimating()
        setupTableView()
    }
    
    private func setupTableView() {
        
        self.addSubview(tableView)
        self.addSubview(activityView)
        NSLayoutConstraint.activate([
            
            activityView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func displayPokemons() {
        self.activityView.stopAnimating()
        self.activityView.isHidden = true
        self.tableView.reloadData()
    }
}

