//
//  Moves.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/5/21.
//

import Foundation
import SwiftUI

enum types: Identifiable {
       case fire, water, grass, electric, fighting, dragon, ghost, normal, flying, psychic, steel, ground, ice, fairy

       var id: Int {
           self.hashValue
       }
}


struct moveModel: Identifiable {
    let id: Int
    let moveName: String
    let moveDamage: Int
    let pp: Int
    let moveType: types?
    let emoji: String
}

class movesObserver: ObservableObject {
    var moves = [moveModel]()
    
    init() {
        moves.append(moveModel(id: 1, moveName: "Aura Pulse", moveDamage: 90, pp: 10, moveType: .fighting, emoji: "🎆"))
        moves.append(moveModel(id: 2, moveName: "Shadow Sphere", moveDamage: 80, pp: 15, moveType: .ghost, emoji: "🌑"))
        moves.append(moveModel(id: 3, moveName: "Dragon Blast", moveDamage: 85, pp: 10, moveType: .dragon, emoji: "☄️"))
        moves.append(moveModel(id: 4, moveName: "Aura Sword", moveDamage: 100, pp: 5, moveType: .steel, emoji: "🗡"))
        
        moves.append(moveModel(id: 5, moveName: "Thunder Strike", moveDamage: 100, pp: 5, moveType: .electric, emoji: "🌩"))
        moves.append(moveModel(id: 6, moveName: "Tackle", moveDamage: 60, pp: 20, moveType: .normal, emoji: "🤼"))
        moves.append(moveModel(id: 7, moveName: "Metal Tail", moveDamage: 75, pp: 15, moveType: .steel, emoji: "🦾"))
        moves.append(moveModel(id: 8, moveName: "Swift", moveDamage: 60, pp: 20, moveType: .normal, emoji: "🌟"))
        
        moves.append(moveModel(id: 9, moveName: "Flamethrower", moveDamage: 90, pp: 10, moveType: .fire, emoji: "♨️"))
        moves.append(moveModel(id: 10, moveName: "Dragon Claw", moveDamage: 80, pp: 15, moveType: .dragon, emoji: "🐲"))
        moves.append(moveModel(id: 11, moveName: "Fly", moveDamage: 90, pp: 10, moveType: .flying, emoji: "🕊"))
        moves.append(moveModel(id: 12, moveName: "Power Punch", moveDamage: 70, pp: 15, moveType: .fighting, emoji: "👊"))
        
        moves.append(moveModel(id: 13, moveName: "Solar Beam", moveDamage: 120, pp: 3, moveType: .grass, emoji: "☀️"))
        moves.append(moveModel(id: 14, moveName: "Leaf Storm", moveDamage: 85, pp: 10, moveType: .grass, emoji: "🍂"))
        moves.append(moveModel(id: 15, moveName: "Earthquake", moveDamage: 100, pp: 5, moveType: .ground, emoji: "🌎"))
        moves.append(moveModel(id: 16, moveName: "Body Slam", moveDamage: 85, pp: 10, moveType: .normal, emoji: "🤾"))
        
        moves.append(moveModel(id: 17, moveName: "Water Cannon", moveDamage: 100, pp: 5, moveType: .water, emoji: "🔫"))
        moves.append(moveModel(id: 18, moveName: "Headbutt", moveDamage: 80, pp: 15, moveType: .normal, emoji: "💀"))
        moves.append(moveModel(id: 19, moveName: "Ice Blast", moveDamage: 75, pp: 15, moveType: .ice, emoji: "❄️"))
        moves.append(moveModel(id: 20, moveName: "Tsunami", moveDamage: 85, pp: 10, moveType: .water, emoji: "🌊"))
        
        moves.append(moveModel(id: 21, moveName: "Psychic Blast", moveDamage: 120, pp: 3, moveType: .psychic, emoji: "✨"))
        moves.append(moveModel(id: 22, moveName: "Telekinesis", moveDamage: 100, pp: 5, moveType: .psychic, emoji: "🧠"))
        moves.append(moveModel(id: 23, moveName: "Hurricane", moveDamage: 90, pp: 10, moveType: .flying, emoji: "🌪"))
        
        moves.append(moveModel(id: 24, moveName: "Hyper Blast", moveDamage: 120, pp: 3, moveType: .normal, emoji: "💥"))
        moves.append(moveModel(id: 25, moveName: "Fairy Beam", moveDamage: 90, pp: 10, moveType: .fairy, emoji: "🌈"))
        
        moves.append(moveModel(id: 26, moveName: "Inferno Spin", moveDamage: 90, pp: 10, moveType: .fire, emoji: "🌈"))
        moves.append(moveModel(id: 27, moveName: "Psychic Shards", moveDamage: 85, pp: 10, moveType: .psychic, emoji: "🪡"))
        moves.append(moveModel(id: 28, moveName: "Feather Storm", moveDamage: 70, pp: 15, moveType: .flying, emoji: "🪶"))
        moves.append(moveModel(id: 29, moveName: "Iron Hammer", moveDamage: 100, pp: 5, moveType: .steel, emoji: "🔨"))
        moves.append(moveModel(id: 30, moveName: "Jump Kick", moveDamage: 85, pp: 10, moveType: .fighting, emoji: "🦵"))
        moves.append(moveModel(id: 31, moveName: "Wood Smash", moveDamage: 90, pp: 10, moveType: .grass, emoji: "🪵"))
        moves.append(moveModel(id: 32, moveName: "Aqua Blast", moveDamage: 90, pp: 10, moveType: .water, emoji: "🚿"))
        moves.append(moveModel(id: 33, moveName: "Shadow Raid", moveDamage: 90, pp: 10, moveType: .ghost, emoji: "🕳"))
        moves.append(moveModel(id: 34, moveName: "Bamboo Slash", moveDamage: 75, pp: 15, moveType: .grass, emoji: "🎋"))
        moves.append(moveModel(id: 35, moveName: "Eruption", moveDamage: 120, pp: 3, moveType: .fire, emoji: "🌋"))
        moves.append(moveModel(id: 36, moveName: "Dragon Rage", moveDamage: 100, pp: 5, moveType: .dragon, emoji: "🐲"))
        moves.append(moveModel(id: 37, moveName: "Thunder Wave", moveDamage: 90, pp: 10, moveType: .electric, emoji: "📡"))


        
    }
    
}
