//
//  APIResponse.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/10/25.
//
import Foundation
import UIKit

struct APIResponse: Decodable {
    let next : String?
    let count: Int
    let results: [PokemonListResult]
}

struct PokemonListResult: Decodable {
    let name: String
    let url: String
    var id: Int? {
        return Int(self.url.split(separator: "/").last.map(String.init) ?? "")
    }
}
