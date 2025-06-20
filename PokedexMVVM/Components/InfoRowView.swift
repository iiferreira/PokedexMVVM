//
//  InfoRowView.swift
//  PokedexCleanSwift
//
//  Created by Iuri Ferreira on 5/28/25.
//


import UIKit

class InfoRowView: UIStackView {

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

    init(title: String, value: String) {
        super.init(frame: .zero)
        setup(title: title, value: value)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(title: String, value: String) {
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "\(title):"
        valueLabel.text = value

        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(valueLabel)
    }

    public func updateValue(_ newValue: String) {
        valueLabel.text = newValue
    }
    
    public func updateFontSizeForTitle(_ size: CGFloat) {
        titleLabel.font = .systemFont(ofSize: size, weight: .medium)
    }
}
