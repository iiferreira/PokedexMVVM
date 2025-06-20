//
//  PokemonDetailViewController.swift
//  PokedexCleanSwift
//
//  Created by Iuri Ferreira on 5/28/25.
//


import UIKit

class PokemonDetailInfoViewController : UIViewController {
    
    var pokemon: Pokemon
    var infoView: PokemonDetailInfoView = PokemonDetailInfoView()
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = infoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.configureWith(pokemon)
    }
}
