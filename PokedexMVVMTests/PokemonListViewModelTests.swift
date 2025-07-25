

import XCTest
@testable import PokedexMVVM

final class PokemonListViewModelTests: XCTestCase {

    func test_fetchPokemons_success_shouldUpdateListAndCallDisplay() async throws {
        // Arrange
        let mockService = MockPokemonService(mode: .successInitial)
        let viewModel = PokemonListViewViewModelImpl(service: mockService)

        let expectation = XCTestExpectation(description: "Display callback should be called")
        viewModel.displayData = {
            expectation.fulfill()
        }

        
        try await viewModel.fetchPokemons()

        XCTAssertEqual(viewModel.pokemonList.count, 2)
        XCTAssertEqual(viewModel.pokemonList.first?.name, "bulbasaur")
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func test_fetchPokemons_failure_shouldThrowError() async {
        
        let mockService = MockPokemonService(mode: .failure)
        let viewModel = PokemonListViewViewModelImpl(service: mockService)

        do {
           
            try await viewModel.fetchPokemons()
            XCTFail("Expected error, but got success")
        } catch {
           
            XCTAssertTrue(error is URLError)
        }
    }

    func test_loadMorePokemons_success_shouldAppendData() async throws {
        
        let mockInitial = MockPokemonService(mode: .successInitial)
        let viewModel = PokemonListViewViewModelImpl(service: mockInitial)

        try await viewModel.fetchPokemons()

        let mockMore = MockPokemonService(mode: .successMore)
        viewModel.setService(mockMore)
        
        try await viewModel.loadMorePokemons()

        XCTAssertEqual(viewModel.pokemonList.count, 4)
        XCTAssertEqual(viewModel.pokemonList.last?.name, "pikachu")
    }
}
