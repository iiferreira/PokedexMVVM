class RandomPokemonDetailViewModel : PokemonDetail_Protocol {
    
    init() {}
    
    var displayPokemonDetail: PokemonData?
    
    var isFavorite: Bool = false
    
    func checkFavoriteStatus() {
        print("Is favorite")
    }
    
    func fetchPokemonDetail() async throws {
        let APIResponse : APIResponse = try await NetworkManager.shared.fetchData(from: Endpoint.short.url)
        let pokemonCount = APIResponse.count - 300
                
        do {
            let pokemon : Pokemon = try await NetworkManager.shared.fetchData(from: Endpoint.pokemon(Int.random(in: 1...pokemonCount)).url)
            self.displayPokemonDetail?(pokemon,PokemonColor(color: .init(name: "red")))
        } catch {
            print(error)
        }
    }
    
    func fetchPokemonColor() async throws -> PokemonColor {
        print("Fetch pokemon color")
        return PokemonColor(color: .init(name: "red"))
    }
    
    func favoritePokemon() {
        print("Favorite pokemon")
    }
}
