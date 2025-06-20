//
//  StatBarView.swift
//  PokedexCleanSwift
//
//  Created by Iuri Ferreira on 5/29/25.
//


import UIKit

class StatBarView: UIView {

    private let backgroundBar = UIView()
    private let fillBar = UIView()

    // Value between 0.0 and 1.0
    private(set) var progress: CGFloat = 1.0

    // Customization
    var barColor: UIColor = .systemGreen {
        didSet { fillBar.backgroundColor = barColor }
    }

    var trackColor: UIColor = .systemGray3 {
        didSet { backgroundBar.backgroundColor = trackColor }
    }

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        layer.cornerRadius = 6
        clipsToBounds = true

        backgroundBar.backgroundColor = trackColor
        fillBar.backgroundColor = barColor

        backgroundBar.layer.cornerRadius = 6
        fillBar.layer.cornerRadius = 6

        backgroundBar.translatesAutoresizingMaskIntoConstraints = false
        fillBar.translatesAutoresizingMaskIntoConstraints = false

        addSubview(backgroundBar)
        backgroundBar.addSubview(fillBar)

        NSLayoutConstraint.activate([
            backgroundBar.topAnchor.constraint(equalTo: topAnchor),
            backgroundBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundBar.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        // Width constraint we animate
        fillWidthConstraint = fillBar.widthAnchor.constraint(equalTo: backgroundBar.widthAnchor, multiplier: progress)
        NSLayoutConstraint.activate([
            fillBar.topAnchor.constraint(equalTo: backgroundBar.topAnchor),
            fillBar.bottomAnchor.constraint(equalTo: backgroundBar.bottomAnchor),
            fillBar.leadingAnchor.constraint(equalTo: backgroundBar.leadingAnchor),
            fillWidthConstraint
        ])
    }

    private var fillWidthConstraint: NSLayoutConstraint!

    /// Update the progress bar value (between 0.0 and 1.0) with animation
    func setProgress(to value: CGFloat, animated: Bool = true, duration: TimeInterval = 0.25) {
        let clamped = max(0.0, min(1.0, value))
        progress = clamped

        fillWidthConstraint.isActive = false
        fillWidthConstraint = fillBar.widthAnchor.constraint(equalTo: backgroundBar.widthAnchor, multiplier: clamped)
        fillWidthConstraint.isActive = true

        if animated {
            UIView.animate(withDuration: duration) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
    }
}
