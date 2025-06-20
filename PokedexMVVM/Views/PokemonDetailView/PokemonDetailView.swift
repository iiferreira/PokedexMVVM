//
//  PokemonDetailView.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/12/25.
//

import UIKit

protocol PokemonDetailViewDelegate : AnyObject {
    func didTapSegmentedControl(_ sender: UISegmentedControl)
}

class PokemonDetailView: UIView {
    
    weak var delegate : PokemonDetailViewDelegate?
    
    lazy var name : UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .white
        name.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        return name
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let containerView : UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 32
        return containerView
    }()
    
    var segmentedControl : UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["About", "Base Stats","Moves"])
        segmentedControl.setWidth(100, forSegmentAt: 0)
        segmentedControl.setWidth(100, forSegmentAt: 1)
        segmentedControl.setWidth(100, forSegmentAt: 2)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupSegmentedControlActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        self.backgroundColor = .gray
        //navigationController?.navigationBar.isHidden = true
        
        self.addSubview(containerView)
        self.addSubview(name)
        self.addSubview(imageView)
        containerView.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            
            name.topAnchor.constraint(equalTo: self.topAnchor,constant: 50),
            name.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: -70),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            
            containerView.topAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: 15),
            
            segmentedControl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            segmentedControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
        ])
    }
    
    func configureWith(pokemon: Pokemon, color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            self?.backgroundColor = color
            self?.name.text = pokemon.name.capitalized
            self?.imageView.kf.setImage(with: URL(string: pokemon.imageURL))
        }
    }
    
    private func setupSegmentedControlActions() {
        self.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.didTapSegmentedControl(sender)
    }
    
}
