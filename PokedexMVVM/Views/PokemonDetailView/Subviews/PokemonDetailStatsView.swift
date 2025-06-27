//
//  PokemonDetailInfoView 2.swift
//  PokedexCleanSwift
//
//  Created by Iuri Ferreira on 5/28/25.
//


import Foundation
import UIKit

final class PokemonDetailStatsView : UIView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureWith(_ viewModel: [InfoRowViewModel], color: UIColor) {
        viewModel.forEach {
            guard let progress = Double($0.value) else { return }
            let row = StatsInfoRowView(title: $0.title.uppercased(), value: $0.value,progress: 0)
            row.updateValue($0.value, progress: CGFloat(progress / 100))
            row.updateColor(color)
            row.updateFontSizeForTitle(11)
            stackView.addArrangedSubview(row)
        }
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 18),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -18),
        ])
    }
}
