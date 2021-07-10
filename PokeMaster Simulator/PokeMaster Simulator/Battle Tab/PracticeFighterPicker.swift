//
//  PracticeFighterPicker.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/26/21.
//

import SwiftUI

struct PracticeFighterPicker: View {
    @ObservedObject var pokemonObserved: pokemonObserver
    @ObservedObject var movesObserved: movesObserver
    
    @State var showNavLink = false
    @State var navLinkPokemonIndex = 0
    @State var selectedPokemon: [Int] = []
    
    var body: some View {
        Form {
            ForEach(pokemonObserved.pokemon.indices) { pokemonIndex in
                Section {
                    PokemonCardView(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonIndex: pokemonIndex, forWhat: .constant([.practice]), selectedPokemon: $selectedPokemon, showNavLink: $showNavLink, returnedPokemonIndex: $navLinkPokemonIndex)
                }

            }
            
        }.navigationBarTitle("Select Your Fighter")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: PracticeFoePicker(pokemonObserved: pokemonObserved, movesObserved: movesObserved, selectedFighter: $selectedPokemon)) {
                    Image(systemName: "arrow.right.circle")
                }.disabled(selectedPokemon.count == 0)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink(destination: PokemonInfoCard(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonIndex: navLinkPokemonIndex, selectedPokemon: $selectedPokemon, showNavLink: $showNavLink, forWhat: .constant("selection"), forWhatSelectButton: .constant([.practice, .full])), isActive: $showNavLink) {
                    EmptyView()
                }
            }
            
        }
    }
}

struct PracticePicker_Previews: PreviewProvider {
    static var previews: some View {
        PracticeFighterPicker(pokemonObserved: pokemonObserver(), movesObserved: movesObserver())
    }
}
