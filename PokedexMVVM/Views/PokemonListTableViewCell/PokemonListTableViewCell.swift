//
//  PokemonListTableViewCell.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 03/06/25.
//

import UIKit
import Kingfisher

final class PokemonTableViewCell : UITableViewCell {
    
    static let cellIdentifier = "pokemonCellIdentifier"
    
    public lazy var containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var number : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemYellow
        return label
    }()
    
    private lazy var name : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        //TODO: - Fix Mudar aqui
        label.textColor = .white
        return label
    }()
    
    private lazy var pokemonImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var pokemonBackground : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemFill
        view.transform = CGAffineTransform(a: 1, b: 0, c: -0.7, d: 1, tx: 0, ty: 0)
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemBackground
        setupCellView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
    
    override func prepareForReuse() {
        self.backgroundColor = .systemBackground
        //FIX: - Mudar aqui
        self.containerView.backgroundColor = .black
        pokemonBackground.backgroundColor = .systemFill
        pokemonImageView.image = nil
        name.text = nil
        number.text = nil
    }
    
    private func setupCellView() {
        self.contentView.addSubview(containerView)
        self.containerView.addSubview(number)
        self.containerView.addSubview(name)
        self.containerView.addSubview(pokemonBackground)
        self.containerView.addSubview(pokemonImageView)
        pokemonImageView.bringSubviewToFront(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 14),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -14),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20),
            
            number.bottomAnchor.constraint(equalTo: centerYAnchor,constant: -10),
            number.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            number.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            name.topAnchor.constraint(equalTo: number.bottomAnchor),
            name.leadingAnchor.constraint(equalTo: number.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: pokemonBackground.leadingAnchor),
            
            pokemonBackground.leadingAnchor.constraint(equalTo: containerView.centerXAnchor,constant: 30),
            pokemonBackground.topAnchor.constraint(equalTo: containerView.topAnchor),
            pokemonBackground.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            pokemonBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: 40),
            
            pokemonImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            pokemonImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 90),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    public func configure(with pokemon: PokemonCellViewModel) {
        self.name.text = pokemon.name
        self.number.text = pokemon.number
        
        guard let imageURL = URL(string: pokemon.imageURL) else {
            self.pokemonImageView.image = nil
            return
        }
        
        let targetSize = CGSize(width: 32, height: 32)
        let processor = DownsamplingImageProcessor(size: targetSize)
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ]
        
        self.pokemonImageView.kf.setImage(
            with: imageURL,
            options: options
        )
    }
}
