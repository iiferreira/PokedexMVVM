import Foundation

class RandomPokemonDetailViewModel {
    
    init() {}
    
    var allPokemons = [PokemonListResult]()
    var pokemonCount = 0
    
    var displayRandomPokemon : ((PokemonListResult) -> ())?
    
    func fetchRandomPokemon() async {
        
        if allPokemons.isEmpty {
            do {
                let apiResponse : APIResponse = try await NetworkManager.shared.fetchData(from: Endpoint.full.url)
                self.allPokemons = apiResponse.results
                self.pokemonCount = apiResponse.count
            } catch {
                print(error)
            }
        }
        
        let pokemon = allPokemons[Int.random(in: 0...pokemonCount)] 
        self.displayRandomPokemon?(pokemon)
       
    }
}
