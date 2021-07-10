//
//  Pokemon.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/5/21.
//

import Foundation
import SwiftUI

struct pokemonModel: Identifiable {
    let id: Int
    let pokemonName: String
    let type: types?
    let hp: Int
    let moves: [Int]
}

class pokemonObserver: ObservableObject {
    var pokemon = [pokemonModel]()
    
    init() {
        //base pokemon
        pokemon.append(pokemonModel(id: 1, pokemonName: "Pulsio", type: .fighting, hp: 400, moves: [1,2,3,4]))
        pokemon.append(pokemonModel(id: 2, pokemonName: "Pika", type: .electric, hp: 300, moves: [5,6,7,8]))
        pokemon.append(pokemonModel(id: 3, pokemonName: "Flamizard", type: .fire, hp: 400, moves: [9,10,11,12]))
        pokemon.append(pokemonModel(id: 4, pokemonName: "Greenasaur", type: .grass, hp: 475, moves: [13,14,15,16]))
        pokemon.append(pokemonModel(id: 5, pokemonName: "Blasturtle", type: .water, hp: 430, moves: [17,18,19,20]))
        pokemon.append(pokemonModel(id: 8, pokemonName: "Snorelacks", type: .normal, hp: 500, moves: [12,16,18,24]))
        
        pokemon.append(pokemonModel(id: 6, pokemonName: "DarChomp", type: .ground, hp: 400, moves: [15,18,10,7]))
        pokemon.append(pokemonModel(id: 7, pokemonName: "TalonBlaze", type: .flying, hp: 350, moves: [9,11,23,7]))
        
        pokemon.append(pokemonModel(id: 9, pokemonName: "DragonKnight", type: .dragon, hp: 450, moves: [24,3,11,36]))
        pokemon.append(pokemonModel(id: 10, pokemonName: "Flamiken", type: .fire, hp: 350, moves: [26,35,30,16]))
        pokemon.append(pokemonModel(id: 11, pokemonName: "Jengar", type: .ghost, hp: 400, moves: [33,24,5,19]))
        pokemon.append(pokemonModel(id: 12, pokemonName: "Seaninja", type: .water, hp: 350, moves: [32,30,19,20]))
        pokemon.append(pokemonModel(id: 13, pokemonName: "Hugia", type: .psychic, hp: 500, moves: [27,32,11,5]))
        pokemon.append(pokemonModel(id: 14, pokemonName: "Tyranisar", type: .ground, hp: 450, moves: [16,15,3,29]))
        pokemon.append(pokemonModel(id: 15, pokemonName: "Electridos", type: .electric, hp: 400, moves: [11,5,37,7]))
        pokemon.append(pokemonModel(id: 16, pokemonName: "Blazetres", type: .fire, hp: 400, moves: [26,28,35,24]))
        pokemon.append(pokemonModel(id: 17, pokemonName: "Raptor", type: .flying, hp: 350, moves: [28,23,14,25]))
        pokemon.append(pokemonModel(id: 18, pokemonName: "Sceptar", type: .grass, hp: 400, moves: [34,33,31,30]))
        pokemon.append(pokemonModel(id: 19, pokemonName: "Inferno", type: .fire, hp: 400, moves: [26,12,7,13]))
        pokemon.append(pokemonModel(id: 20, pokemonName: "Girachi", type: .steel, hp: 400, moves: [29,27,21,7]))
        pokemon.append(pokemonModel(id: 21, pokemonName: "Selebe", type: .psychic, hp: 400, moves: [27,34,15,22]))
        
        pokemon.append(pokemonModel(id: 45, pokemonName: "Zerneas", type: .fairy, hp: 400, moves: [13,21,25,8]))
        pokemon.append(pokemonModel(id: 46, pokemonName: "Jiratina", type: .ghost, hp: 450, moves: [2,3,16,1]))
        pokemon.append(pokemonModel(id: 47, pokemonName: "Icycuno", type: .ice, hp: 400, moves: [11,19,5,23]))
        pokemon.append(pokemonModel(id: 48, pokemonName: "Airquaza", type: .dragon, hp: 500, moves: [3,11,10,23]))
        pokemon.append(pokemonModel(id: 49, pokemonName: "Katana", type: .steel, hp: 350, moves: [4,7,5,8]))
        pokemon.append(pokemonModel(id: 50, pokemonName: "Mu", type: .psychic, hp: 500, moves: []))
        pokemon.append(pokemonModel(id: 51, pokemonName: "MuTwo", type: .psychic, hp: 600, moves: [21,22,23,2]))

    }
    
}
