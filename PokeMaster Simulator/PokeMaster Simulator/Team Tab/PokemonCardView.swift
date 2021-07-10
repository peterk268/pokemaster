//
//  PokemonCardView.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/5/21.
//

import SwiftUI

struct PokemonCardView: View {
    @ObservedObject var pokemonObserved: pokemonObserver
    @ObservedObject var movesObserved: movesObserver

    @State var pokemonIndex: Int
    
//    var geo: GeometryProxy
    @Binding var forWhat: [selectForWhat]
    
    @Binding var selectedPokemon: [Int]
    
    @State var uuid = UUID()
    
    @Binding var showNavLink: Bool
    @Binding var returnedPokemonIndex: Int
    
    var body: some View {
        let pokemonData = pokemonObserved.pokemon[pokemonIndex]
//        ForEach(pokemonObserved.pokemon.filter{$0.id == pokemonID}) { i in
            VStack {
                HStack {
                    VStack(spacing: 0) {
                        HStack {
                            Text(pokemonData.pokemonName).font(.headline)
                            Spacer()
                            Text("\(pokemonData.hp) HP").font(.title2).bold().foregroundColor(.green)
                        }
                        HStack {
                            TypeView(type: pokemonData.type, font: .footnote)
                            Button(action: {returnedPokemonIndex = pokemonIndex; showNavLink = true}) {
                                Image(systemName: "info.circle").foregroundColor(.blue)
                            }
                            Spacer()
                            selectButton(pokemonObserved: pokemonObserved, uuid: $uuid, selectedPokemon: $selectedPokemon, forWhat: $forWhat, pokemonIndex: pokemonIndex)
//                            selectButton(uuid: $uuid, selectedPokemon: $selectedPokemon, forWhat: $forWhat, pokemon: i)
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                    
                }
            }.onAppear {
                uuid = UUID()
            }
//        }
    }
    
}

//struct selectButton: View {
//    @Binding var uuid: UUID
//    @Binding var selectedPokemon: [Int]
//    @Binding var forWhat: String
//
//    @State var pokemon: pokemonModel
//
//    var basePokemon = [1,2,3,4,5,8] // if iap then put in mu. and core data unlocked. .contains where unlocked.teamID to check and see if it exists already to show the base pokemon or show all unlocked pokemon.
//
//    var body: some View {
//
//        Button(action: {
//            if selectedPokemon.contains(pokemon.id) {
//                selectedPokemon.removeAll(where: {$0 == pokemon.id})
//            } else {
//                selectedPokemon.append(pokemon.id)
//            }
//        }) {
//            HStack {
//                if selectedPokemon.contains(pokemon.id) {
//                    if forWhat == "full" {
//                        Text("Selected")
//                    }
//                    Image(systemName: "checkmark.circle").foregroundColor(.purple)
//                } else {
//                    if forWhat == "full" {
//                        Text("Select")
//                    }
//                    if !basePokemon.contains(pokemon.id) {
//                        Image(systemName: "lock").foregroundColor(.red)
//                    } else {
//                        Image(systemName: "checkmark")
//                    }
//                }
//            }
//        }.id(uuid.uuidString)
//        .disabled((!selectedPokemon.contains(pokemon.id) && selectedPokemon.count >= 6) || !basePokemon.contains(pokemon.id))
//    }
//}

enum selectForWhat: Identifiable {
    case practice, practiceFoe, full, overview, none

       var id: Int {
           self.hashValue
       }
}

struct selectButton: View {
    @ObservedObject var pokemonObserved: pokemonObserver
    @Binding var uuid: UUID
    @Binding var selectedPokemon: [Int]
    @Binding var forWhat: [selectForWhat]

    @State var pokemonIndex: Int
    
    var basePokemon = [1,2,3,4,5,8] // if iap then put in mu. and core data unlocked. .contains where unlocked.teamID to check and see if it exists already to show the base pokemon or show all unlocked pokemon.
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Unlocked.teamID, ascending: true)], animation: .default)
    private var unlocked: FetchedResults<Unlocked>
    
    @AppStorage ("selectedGame") var selectedGame = 0

    var body: some View {
        let pokemonData = pokemonObserved.pokemon[pokemonIndex]
        let hasBeenUnlocked = basePokemon.contains(pokemonData.id) || unlocked.contains(where: {$0.teamID == selectedGame && $0.pokemonID == pokemonData.id}) || forWhat.contains(.practiceFoe)
        #warning("Not sure if you want full team training or just 1 pokemon.")
        let teamLimit = forWhat.contains(where: {$0 == .practice || $0 == .practiceFoe}) ? 1 : 6
                
        Button(action: {
            if selectedPokemon.contains(pokemonIndex) {
                selectedPokemon.removeAll(where: {$0 == pokemonIndex})
            } else {
                selectedPokemon.append(pokemonIndex)
            }
        }) {
            HStack {
                if selectedPokemon.contains(pokemonIndex) {
                    if forWhat.contains(.full) {
                        Text("Selected")
                    }
                    Image(systemName: "checkmark.circle").foregroundColor(.purple)
                } else {
                    if forWhat.contains(.full) {
                        Text("Select")
                    }
                    if !hasBeenUnlocked {
                        Image(systemName: "lock").foregroundColor(.red)
                    } else {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }.id(uuid.uuidString)
        .disabled((!selectedPokemon.contains(pokemonIndex) && selectedPokemon.count >= teamLimit) || !hasBeenUnlocked)
    }
}

struct ViewGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ViewSizeKey.self, value: geometry.size)
        }
    }
}

struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct TypeView: View {
    var type: types?
    var font: Font
    
    var body: some View {
        if !(type == .none) {
            ZStack {
                RoundedRectangle(cornerRadius: 8).foregroundColor(typeColor(type: type))
                Text(typeText()).bold().font(font).foregroundColor(textColor()).padding(.all, 4).fixedSize(horizontal: true, vertical: false)
            }.fixedSize()
        }
    }
    func textColor() -> Color {
        let blackText: [types?] = [.electric, .normal, .steel]
        if blackText.contains(type) {
            return .black
        } else {
            return .white
        }
    }
    func typeText() -> String {
        switch type {
        case .none:
            return ""
        case .some(.fire):
            return "🔥 Fire"
        case .some(.water):
            return "💧 Water"
        case .some(.grass):
            return "🍃 Grass"
        case .some(.electric):
            return "⚡️ Electric"
        case .some(.fighting):
            return "🥊 Fighting"
        case .some(.dragon):
            return "🐉 Dragon"
        case .some(.ghost):
            return "👻 Ghost"
        case .some(.normal):
            return "🔳 Normal"
        case .some(.flying):
            return "🦅 Flying"
        case .some(.psychic):
            return "🔮 Psychic"
        case .some(.steel):
            return "⛓ Steel"
        case .some(.ground):
            return "🪨 Ground"
        case .some(.ice):
            return "🧊 Ice"
        case .some(.fairy):
            return "🧚‍♀️ Fairy"
        }
    }
}
func typeColor(type: types?) -> Color {
    switch type {
    
    case .none:
        return .white
    case .some(.fire):
        return .red
    case .some(.water):
        return .blue
    case .some(.grass):
        return .green
    case .some(.electric):
        return .yellow
    case .some(.fighting):
        return Color("Fighting")
    case .some(.dragon):
        return Color("Dragon")
    case .some(.ghost):
        return Color("Ghost")
    case .some(.normal):
        return Color("Normal")
    case .some(.flying):
        return Color("Flying")
    case .some(.psychic):
        return .pink
    case .some(.steel):
        return Color("Steel")
    case .some(.ground):
        return Color("Ground")
    case .some(.ice):
        return Color("Ice")
    case .some(.fairy):
        return Color("Fairy")
    }
}


struct PokemonCardView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            Form {
                PokemonCardView(pokemonObserved: pokemonObserver(), movesObserved: movesObserver(), pokemonIndex: 1, forWhat: .constant([.none]), selectedPokemon: .constant([1,2,3,4,5,6]), showNavLink: .constant(false), returnedPokemonIndex: .constant(1))
            }
            
        }
    }
}
