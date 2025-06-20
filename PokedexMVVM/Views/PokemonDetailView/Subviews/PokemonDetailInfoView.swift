
import UIKit


struct InfoRowViewModel {
    let title : String
    let value : String
}

class PokemonDetailInfoView : UIView {
    
    var infoRowViewModel : [InfoRowViewModel] = [
        InfoRowViewModel(title: "Species", value: ""),
        InfoRowViewModel(title: "Height", value: ""),
        InfoRowViewModel(title: "Weight", value: ""),
        InfoRowViewModel(title: "Abilities", value: ""),
    ]
    
    private let speciesRow = InfoRowView(title: "Species", value: "")
    private let heightRow = InfoRowView(title: "Height", value: "")
    private let weightRow = InfoRowView(title: "Weight", value: "")
    private let abilitiesRow = InfoRowView(title: "Abilities", value: "")

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        [speciesRow, heightRow, weightRow, abilitiesRow].forEach {
            stackView.addArrangedSubview($0)
        }
        
//        infoRowViewModel.forEach{
//            let row = InfoRowView(title: $0.title, value: $0.value)
//            stackView.addArrangedSubview(row)
//        }

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 22),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -22),
        ])
    }

    func configureWith(_ pokemon: Pokemon) {
        speciesRow.updateValue(pokemon.species.name.capitalized)
        heightRow.updateValue("\(pokemon.height)")
        weightRow.updateValue("\(pokemon.weight)")

        let abilityNames = pokemon.abilities
            .compactMap { $0.ability?.name.capitalized }
            .joined(separator: ", ")
        abilitiesRow.updateValue(abilityNames)
    }
}
