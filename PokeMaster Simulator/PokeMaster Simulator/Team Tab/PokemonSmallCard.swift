//
//  PokemonSmallCard.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/12/21.
//

import SwiftUI

struct PokemonSmallCard: View {
    @ObservedObject var pokemonObserved: pokemonObserver
    @ObservedObject var movesObserved: movesObserver
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Teams.timestamp, ascending: true)], animation: .default)
    private var teams: FetchedResults<Teams>

    @State var pokemonIndex: Int
    var forWhat: String
    @Binding var health: Int
    
    var geo: GeometryProxy
    
    var geoDivide: CGFloat
    
    var body: some View {
        let pokemonData = pokemonObserved.pokemon[pokemonIndex]
        let pokemonCoreData = teams.filter({$0.pokemonID == pokemonData.id}).first
        let health = forWhat == "fighter" ? pokemonCoreData?.health ?? Int16(pokemonData.hp) : Int16(health)
        
//        ForEach(pokemonObserved.pokemon.filter({$0.id == pokemonData.id})) { i in
            GroupBox {
                NavigationLink(destination: PokemonInfoCard(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonIndex: pokemonIndex, selectedPokemon: .constant([pokemonData.id]), showNavLink: .constant(false), forWhat: .constant("info"), forWhatSelectButton: .constant([.none]))) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(pokemonData.pokemonName).foregroundColor(typeColor(type: pokemonData.type)).bold()
                        
                        ProgressView("", value: Float(health < 0 ? 0 : health), total: Float(pokemonData.hp)).frame(width: geo.size.width/geoDivide)
                            .padding(.top, -10)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                            .animation(.default)
                        Text("\(health < 0 ? 0 : health)/\(pokemonData.hp)HP").font(.caption2).foregroundColor(.secondary).bold()
                    }
                }
            }
//        }
    }
}
//struct healthBar: View {
//    @Binding var health: Int
//    @State var hp: Int
//    var geo: GeometryProxy
//
//    var body: some View {
//        ProgressView("", value: Float(health), total: Float(hp)).foregroundColor(.green).frame(width: geo.size.width/3)
//            .progressViewStyle(LinearProgressViewStyle(tint:
//                health/hp == 1 ? Color.blue : (health/hp > 1/2 ? Color.green : (health/hp <= 1/2 ? Color.orange : (health/hp < 1/4 ? Color.red : Color.blue)))
//            ))
//    }
//}

struct PokemonSmallCard_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            PokemonSmallCard(pokemonObserved: pokemonObserver(), movesObserved: movesObserver(), pokemonIndex: 1, forWhat: "fighter", health: .constant(335), geo: geo, geoDivide: 3)

        }
    }
}
