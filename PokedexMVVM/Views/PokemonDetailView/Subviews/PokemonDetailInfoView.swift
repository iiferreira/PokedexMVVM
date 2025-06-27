
import UIKit


struct InfoRowViewModel {
    let title : String
    let value : String
}

final class PokemonDetailInfoView: UIView {

    private let speciesRow = InfoRowView(title: "Species", value: "")
    private let heightRow = InfoRowView(title: "Height", value: "")
    private let weightRow = InfoRowView(title: "Weight", value: "")
    private let abilitiesRow = InfoRowView(title: "Abilities", value: "")

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            speciesRow,
            heightRow,
            weightRow,
            abilitiesRow
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupLayout() {
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -22),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }

    // MARK: - Configuration

    func configure(with pokemon: Pokemon) {
        speciesRow.updateValue(pokemon.species.name.capitalized)
        heightRow.updateValue("\(pokemon.height)")
        weightRow.updateValue("\(pokemon.weight)")

        let abilities = pokemon.abilities
            .compactMap { $0.ability?.name.capitalized }
            .joined(separator: ", ")

        abilitiesRow.updateValue(abilities)
    }
}
