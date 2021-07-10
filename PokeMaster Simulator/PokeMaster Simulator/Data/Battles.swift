//
//  Battles.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/25/21.
//

import Foundation
import SwiftUI


struct battle: Identifiable {
    let id: Int
    let foeName: String
    let preferredType: types?
    let level: Int
    let pokemonIDs: [Int]
}

class battlesObserver: ObservableObject {
    var battles = [battle]()
    
    init() {
        battles.append(battle(id: 1, foeName: "Blaze", preferredType: .fire, level: 1, pokemonIDs: [3,16,7,10]))
        battles.append(battle(id: 2, foeName: "Gardenia", preferredType: .grass, level: 1, pokemonIDs: [18,4,21,45]))
        battles.append(battle(id: 3, foeName: "Misty", preferredType: .water, level: 1, pokemonIDs: [12,5,13,47]))
        battles.append(battle(id: 4, foeName: "Surge", preferredType: .electric, level: 1, pokemonIDs: [2,15,17,20]))
        battles.append(battle(id: 5, foeName: "Gary", preferredType: .none, level: 1, pokemonIDs: [9,8,49,48,46,51]))
        
        battles.append(battle(id: 6, foeName: "Fli", preferredType: .flying, level: 2, pokemonIDs: [17,7,6,3]))
        battles.append(battle(id: 7, foeName: "Sike", preferredType: .psychic, level: 2, pokemonIDs: [21,13,20,45]))
        battles.append(battle(id: 8, foeName: "Drake", preferredType: .dragon, level: 2, pokemonIDs: [48,9,46,4]))
        battles.append(battle(id: 9, foeName: "Gio", preferredType: .ground, level: 2, pokemonIDs: [14,6,8,18]))
        battles.append(battle(id: 10, foeName: "Paul", preferredType: .none, level: 2, pokemonIDs: [11,49,19,12,1,15]))

    }
    
}

struct Battles_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BattlesPreview(battlesObserved: battlesObserver(), pokemonObserved: pokemonObserver())
        }
    }
}

struct BattlesPreview: View {
    @ObservedObject var battlesObserved: battlesObserver
    @ObservedObject var pokemonObserved: pokemonObserver
    var body: some View {
        Form {
            ForEach(battlesObserved.battles) { i in
                Section {
                    HStack {
                        Image(systemName: i.preferredType == .none ? "rosette":"star.circle")
                            .foregroundColor(i.preferredType == .none ? .red:.blue)
                        Text(i.foeName)
                        TypeView(type: i.preferredType, font: .caption)
                    }
                    ForEach(i.pokemonIDs, id: \.self) { j in
                        ForEach(pokemonObserved.pokemon.filter({$0.id == j})) { k in
                            HStack {
                                Text("\(k.pokemonName)")
                                TypeView(type: k.type, font: .caption)
                            }
                        }
                    }
//                    ForEach(pokemonObserved.pokemon) { p in
//                        if i.pokemonIDs.contains(where: {$0 == p.id}) {
//                            HStack {
//                                Text("\(p.pokemonName)")
//                                TypeView(type: p.type, font: .caption)
//                            }
//                        }
//                    }
                }
            }
        }
//        .toolbar(content: {
//            ToolbarItem {
//                Button(action: {battlesObserved.reload()}) {
//                    Text("reloa")
//                }
//            }
//        })
    }
}
