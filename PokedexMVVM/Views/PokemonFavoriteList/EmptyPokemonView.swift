//
//  EmptyPokemonView.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 03/07/25.
//

import UIKit


final class EmptyPokemonView : UIView {
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "no_pokemon.png")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var label : UILabel = {
        let label = UILabel()
        label.text = "You have no favorites pokemon."
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI () {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemGray3
        self.layer.cornerRadius = 12
        self.addSubview(label)
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 40),
            
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor,constant: -5),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}
