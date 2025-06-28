//
//  Pokemon.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 5/27/25.
//

import UIKit
import Foundation

struct Pokemon: Decodable {
    let abilities: [Ability]
    let height: Int
    let id: Int
    let moves: [Move]
    let name: String
    let species: Species
    let stats: [Stat]
    let weight: Int
    var imageURL : String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(self.id).png"
    }
    
    var url : String {
        return "https://pokeapi.co/api/v2/pokemon/\(self.id)/"
    }
}

struct Ability: Decodable {
    let ability: Species?
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

// MARK: - Species
struct Species: Decodable {
    let name: String
    let url: String
}

// MARK: - Cries
struct Cries: Decodable {
    let latest, legacy: String
}

// MARK: - GameIndex
struct GameIndex: Decodable {
    let gameIndex: Int
    let version: Species

    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
}

// MARK: - Move
struct Move: Decodable {
    let move: Species

    enum CodingKeys: String, CodingKey {
        case move
    }
}

struct Stat: Decodable {
    let baseStat, effort: Int
    let stat: Species

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

struct TypeElement: Decodable {
    let slot: Int
    let type: Species
}
