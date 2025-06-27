//
//  PokemonDetailsViewController.swift
//  PokedexCleanSwift
//
//  Created by Iuri Ferreira on 5/28/25.
//

import UIKit

final class PokemonDetailStatsViewController : UIViewController {
    
    private var pokemon : Pokemon
    private var color : UIColor
    private lazy var statsView : PokemonDetailStatsView = PokemonDetailStatsView()
    
    init(pokemon: Pokemon, color : UIColor) {
        self.pokemon = pokemon
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = statsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var stats : [InfoRowViewModel] = []
        
        pokemon.stats.forEach {
            stats.append(InfoRowViewModel(title: $0.stat.name, value: String($0.baseStat)))
        }
        
        statsView.configureWith(stats,color: color)
    }
}

