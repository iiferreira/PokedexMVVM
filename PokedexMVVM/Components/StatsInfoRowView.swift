//
//  InfoRowView 2.swift
//  PokedexCleanSwift
//
//  Created by Iuri Ferreira on 5/29/25.
//


import UIKit

class StatsInfoRowView: UIStackView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private let barView = StatBarView()

    init(title: String, value: String, progress: CGFloat = 1.0) {
        super.init(frame: .zero)
        setup(title: title, value: value, progress: progress)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(title: String, value: String, progress: CGFloat) {
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = title
        valueLabel.text = value

        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.setProgress(to: progress)
        barView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        barView.barColor = UIColor.blue
        
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(valueLabel)
        self.addArrangedSubview(barView)
    }
    

    public func updateValue(_ newValue: String, progress: CGFloat? = nil) {
        valueLabel.text = newValue
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if let progress = progress {
                self?.barView.setProgress(to: progress)
            }
        }
    }
    
    public func updateColor(_ color: UIColor) {
        barView.barColor = color
    }

    public func updateFontSizeForTitle(_ size: CGFloat) {
        titleLabel.font = .systemFont(ofSize: size, weight: .medium)
    }
}
