
import Foundation

protocol PokemonServiceProtocol {
    func fetchInitialPokemons() async throws -> APIResponse
    func fetchMorePokemons(from url: String) async throws -> APIResponse
}

final class PokemonService: PokemonServiceProtocol {
    func fetchInitialPokemons() async throws -> APIResponse {
        try await NetworkManager.shared.fetchData(from: Endpoint.short.url)
    }

    func fetchMorePokemons(from url: String) async throws -> APIResponse {
        try await NetworkManager.shared.fetchData(from: url)
    }
}
