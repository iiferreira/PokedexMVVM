import Foundation

final class RandomPokemonDetailViewModel {

    private var allPokemons: [PokemonListResult] = []
    private var pokemonCount: Int { allPokemons.count }

    var onDisplayRandomPokemon: ((PokemonListResult) -> Void)?

    func fetchRandomPokemon() async throws {
        if allPokemons.isEmpty {
            try await loadAllPokemons()
        }

        guard !allPokemons.isEmpty else { return }

        let randomIndex = Int.random(in: 0..<pokemonCount)
        let randomPokemon = allPokemons[randomIndex]
        onDisplayRandomPokemon?(randomPokemon)
    }

    private func loadAllPokemons() async throws {
        do {
            let response: APIResponse = try await NetworkManager.shared.fetchData(from: Endpoint.full.url)
            self.allPokemons = response.results
        } catch {
            print("Failed to load all Pokémons: \(error)")
            throw error
        }
    }
}
