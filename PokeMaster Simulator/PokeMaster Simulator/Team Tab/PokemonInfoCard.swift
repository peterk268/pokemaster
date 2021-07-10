//
//  PokemonInfoCard.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/11/21.
//

import SwiftUI

//struct infoTabView: View {
//    @ObservedObject var pokemonObserved: pokemonObserver
//    @ObservedObject var movesObserved: movesObserver
//
//    @Binding var selection: Int
//    @Binding var selectedPokemon: [Int]
//
//    var body: some View {
//        TabView(selection: $selection) {
//            ForEach(pokemonObserved.pokemon) { i in
//                NavigationView {
//                    PokemonInfoCard(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonID: selection, selectedPokemon: $selectedPokemon)
//                }.navigationViewStyle(StackNavigationViewStyle())
//            }
//
//        }
//        .edgesIgnoringSafeArea(.top)
//        .tabViewStyle(PageTabViewStyle())
//        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
//
//    }
//}

struct PokemonInfoCard: View {
    @ObservedObject var pokemonObserved: pokemonObserver
    @ObservedObject var movesObserved: movesObserver

    @State var pokemonIndex: Int
    @Binding var selectedPokemon: [Int]
    
    @Binding var showNavLink: Bool
    
//    @Environment(\.presentationMode) var presentationMode

    @State var uuid = UUID()
    
    @Binding var forWhat: String
    @Binding var forWhatSelectButton: [selectForWhat]
    
    @State var textSize: CGSize = .zero
    @State var column = [GridItem(.flexible())]
    var body: some View {
        let pokemonData = pokemonObserved.pokemon[pokemonIndex]
        
//        ForEach(pokemonObserved.pokemon.filter{$0.id == pokemonID}) { i in
            Form {
                Section {
                    HStack {
                        TypeView(type: pokemonData.type, font: .footnote)
                        Spacer()
                        Text("\(pokemonData.hp) HP").font(.title2).bold().foregroundColor(.green)
                    }
                }
                
                Section(header: Text("💥 Moves")) {
                    MoveSetView(pokemon: pokemonData, movesObserved: movesObserved)
                }
                
                StrWeakView(column: column, type: pokemonData.type)
                
            }.navigationBarTitle(pokemonData.pokemonName)
            .onAppear{
                showNavLink = false
            }
            .toolbar(content: {
                ToolbarItem(placement: .bottomBar) {
                    Group {
                        if forWhat == "selection" {
                            selectButton(pokemonObserved: pokemonObserved, uuid: $uuid, selectedPokemon: $selectedPokemon, forWhat: $forWhatSelectButton, pokemonIndex: pokemonIndex)
//                            selectButton(uuid: $uuid, selectedPokemon: $selectedPokemon, forWhat: $forWhatSelectButton, pokemon: pokemonData)
                        }
                    }
                }
            })
//            .onAppear {
//                uuid = UUID()
//            }
//        }

        
    }
}

struct StrWeakView: View {
    @State var column: [GridItem]
    @State var type: types?
    var body: some View {
        Section(header: Text("💪 Strengths")) {
            LazyVGrid(columns: column, alignment: .leading, content: {
                ForEach(strengths(type: type), id: \.self) {
                    TypeView(type: $0, font: .footnote)
                }
            })
        }
        
        Section(header: Text("⚠️ Weaknesses")) {
            LazyVGrid(columns: column, alignment: .leading, content: {
                ForEach(weaknesses(type: type), id: \.self) {
                    TypeView(type: $0, font: .footnote)
                }
            })
        }
    }
}

struct MoveSetView: View {

    @State var column = [GridItem(.flexible())]
    @State var pokemon: pokemonModel
    @ObservedObject var movesObserved: movesObserver

    var body: some View {
        HStack {

            if pokemon.id == 50 {
                Text("Teach Any Move").bold()
            } else {
                LazyVGrid(columns: column, alignment: .leading, spacing: nil, content: {
                    ForEach(pokemon.moves, id: \.self) { j in
                        ForEach(movesObserved.moves.filter{$0.id == j}) { k in
                            Text("\(k.moveName) || \(k.moveDamage) Damage || \(k.pp)PP")
                                .bold()
                                .font(.caption)
                                .fixedSize(horizontal: true, vertical: false)
                                .foregroundColor(typeColor(type: k.moveType))

                        }
                    }
                })
            }

        }
    }
}

func strengths(type: types?) -> [types] {
    switch type {
    
    case .fire:
        return [.grass, .ice, .steel]
    case .water:
        return [.fire, .ground]
    case .grass:
        return [.ground, .water]
    case .electric:
        return [.water, .flying]
    case .fighting:
        return [.normal, .ice, .steel]
    case .dragon:
        return [.dragon]
    case .ghost:
        return [.ghost, .psychic]
    case .normal:
        return []
    case .flying:
        return [.fighting, .grass]
    case .psychic:
        return [.fighting]
    case .steel:
        return [.fairy, .ice]
    case .ground:
        return [.electric, .fire, .steel]
    case .ice:
        return [.dragon, .flying, .grass, .ground]
    case .fairy:
        return [.fighting, .dragon]
        
    case .none:
        return []
    }
}

func weaknesses(type: types?) -> [types] {
    switch type {
    
    case .fire:
        return [.water, .ground]
    case .water:
        return [.grass, .electric]
    case .grass:
        return [.fire, .flying, .ice]
    case .electric:
        return [.ground]
    case .fighting:
        return [.fairy, .flying, .psychic]
    case .dragon:
        return [.dragon, .fairy, .ice]
    case .ghost:
        return [.ghost]
    case .normal:
        return [.fighting]
    case .flying:
        return [.electric, .ice]
    case .psychic:
        return [.ghost]
    case .steel:
        return [.fighting, .fire, .ground]
    case .ground:
        return [.grass, .water, .ice]
    case .ice:
        return [.fighting, .fire, .steel]
    case .fairy:
        return [.steel]
    case .none:
        return []
    }
}

struct PokemonInfoCard_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoCard(pokemonObserved: pokemonObserver(), movesObserved: movesObserver(), pokemonIndex: 1, selectedPokemon: .constant([1,2,3,4,5]), showNavLink: .constant(false), forWhat: .constant("info"), forWhatSelectButton: .constant([.full]))

    }
}
