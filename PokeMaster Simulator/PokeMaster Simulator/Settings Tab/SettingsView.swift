//
//  SettingsView.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/13/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var pokemonObserved: pokemonObserver
    @ObservedObject var movesObserved: movesObserver
    
    @Binding var tabSelect: Int
    @State var gameSelect = false
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Teams.timestamp, ascending: true)], animation: .default)
    private var teams: FetchedResults<Teams>
    
    var body: some View {
        Form {
            NavigationLink(destination: SelectGameView(pokemonObserved: pokemonObserved, movesObserved: movesObserved, tabSelect: $tabSelect)) {
                HStack {
                    Image(systemName: "folder").foregroundColor(.pink)
                    Text("Game Selection")
                }
            }.disabled(teams.isEmpty)
        }.navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(pokemonObserved: pokemonObserver(), movesObserved: movesObserver(), tabSelect: .constant(1))
    }
}
