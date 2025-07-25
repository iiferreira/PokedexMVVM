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

final class PokemonDetailView: UIView {
    
    weak var delegate : PokemonDetailViewDelegate?
    
    lazy var name : UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.adjustsFontSizeToFitWidth = true
        name.textColor = .white
        name.textAlignment = .center
        name.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        return name
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private(set) lazy var containerView : UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 32
        return containerView
    }()
    
    private(set) lazy var segmentedControl : UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["About", "Base Stats"])
        segmentedControl.setWidth(100, forSegmentAt: 0)
        segmentedControl.setWidth(100, forSegmentAt: 1)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private lazy var stackView : UIStackView = {
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
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        self.backgroundColor = .gray
        //navigationController?.navigationBar.isHidden = true
        
        self.addSubview(containerView)
        self.addSubview(name)
        self.addSubview(activityIndicator)
        self.addSubview(imageView)
        containerView.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            
            name.topAnchor.constraint(equalTo: self.topAnchor,constant: 50),
            name.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            name.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 25),
            name.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: -70),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: -70),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            containerView.topAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: 15),
            
            segmentedControl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            segmentedControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
        ])
    }
    
    public func configureWith(pokemon: Pokemon, color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.backgroundColor = color
            self.name.text = pokemon.name.capitalized
            
            guard let url = URL(string: pokemon.imageURL) else {
                self.imageView.image = nil
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                return
            }
            
            self.imageView.kf.setImage(with: url, completionHandler: { [weak self] result in
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            })
        }
    }
    
    private func setupSegmentedControlActions() {
        self.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.didTapSegmentedControl(sender)
    }
    
}
