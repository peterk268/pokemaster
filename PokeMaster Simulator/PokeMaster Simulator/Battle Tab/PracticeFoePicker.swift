//
//  PracticeFoePicker.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/26/21.
//

import SwiftUI

struct PracticeFoePicker: View {
    @ObservedObject var pokemonObserved: pokemonObserver
    @ObservedObject var movesObserved: movesObserver
    
    @State var showNavLink = false
    @State var navLinkPokemonIndex = 0
    @Binding var selectedFighter: [Int]
    @State var selectedFoe: [Int] = []
    
    var body: some View {
        Form {
            ForEach(pokemonObserved.pokemon.indices) { pokemonIndex in
                Section {
                    PokemonCardView(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonIndex: pokemonIndex, forWhat: .constant([.practiceFoe]), selectedPokemon: $selectedFoe, showNavLink: $showNavLink, returnedPokemonIndex: $navLinkPokemonIndex)
                }

            }
            
        }.navigationBarTitle("Select Your Foe")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: BattleView(pokemonObserved: pokemonObserved, movesObserved: movesObserved, fighterIndex: selectedFighter.first ?? 0, foeIndex: selectedFoe.first ?? 0, fighterHealth: pokemonObserved.pokemon[selectedFighter.first ?? 0].hp, foeHealth: pokemonObserved.pokemon[selectedFoe.first ?? 0].hp)) {
                    Image(systemName: "arrow.right.circle")
                }.disabled(selectedFoe.count == 0)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink(destination: PokemonInfoCard(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonIndex: navLinkPokemonIndex, selectedPokemon: $selectedFoe, showNavLink: $showNavLink, forWhat: .constant("selection"), forWhatSelectButton: .constant([.practiceFoe, .full])), isActive: $showNavLink) {
                    EmptyView()
                }
            }
            
        }
    }
}

struct PracticeFoePicker_Previews: PreviewProvider {
    static var previews: some View {
        PracticeFoePicker(pokemonObserved: pokemonObserver(), movesObserved: movesObserver(), selectedFighter: .constant([1]))
    }
}
