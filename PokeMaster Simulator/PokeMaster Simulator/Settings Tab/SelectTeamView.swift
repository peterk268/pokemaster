//
//  SelectTeamView.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/5/21.
//

import SwiftUI

struct SelectTeamView: View {
    @ObservedObject var pokemonObserved: pokemonObserver
    @ObservedObject var movesObserved: movesObserver
    
    //core data variables
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Teams.timestamp, ascending: true)], animation: .default)
    private var teams: FetchedResults<Teams>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Levels.teamID, ascending: true)], animation: .default)
    private var levels: FetchedResults<Levels>
    
    @AppStorage ("selectedGame") var selectedGame = 0
    @AppStorage ("currentLevel") var currentLevel = 1
    var teamID: Int16
    
    @State var selectedPokemon: [Int] = []
    
//    @State var navLink = false
    
    @State var showNavLink = false
    @State var navLinkPokemonIndex = 0
    
    @Binding var tabSelect: Int
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geo in
          
//            #warning("fix this into a button to switch tabs")
            
//            NavigationLink(destination: TeamOverview(pokemonObserved: pokemonObserved, movesObserved: movesObserved, teamID: teamID, navLink: $navLink).onAppear{
//                UserDefaults.standard.setValue(Int(teamID), forKey: "selectedGame")
//            }, isActive: $navLink, label: {
//                EmptyView()
//            })
            
            Form {
                ForEach(pokemonObserved.pokemon.indices) { pokemondIndex in
                    Section {
                        PokemonCardView(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonIndex: pokemondIndex, forWhat: .constant([.overview]), selectedPokemon: $selectedPokemon, showNavLink: $showNavLink, returnedPokemonIndex: $navLinkPokemonIndex)
                    }
                }
            }.navigationTitle("Select Your Team")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        deselectFromTeam()
                        for index in selectedPokemon {
                            save(pokemonObserved: pokemonObserved, pokemonIndex: index, teamID: teamID)
                        }
                        addLevelToOne(teamID: teamID)
                        
                        selectedGame = Int(teamID)
                        currentLevel = 1
                        
                        tabSelect = 2
                        presentationMode.wrappedValue.dismiss()
//                        navLink = true
                    }) {
                        Image(systemName: "arrow.right.circle")
                    }.disabled(selectedPokemon.count == 0)
//                    NavigationLink(destination: TeamOverview(pokemonObserved: pokemonObserved, movesObserved: movesObserved, teamID: teamID, navLink: .constant(false)), isActive: $navLink) {
//                        EmptyView()
//                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Text("Select up to 6 Fighters").font(.footnote).bold()
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: PokemonInfoCard(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonIndex: navLinkPokemonIndex, selectedPokemon: $selectedPokemon, showNavLink: $showNavLink, forWhat: .constant("selection"), forWhatSelectButton: .constant([.full])), isActive: $showNavLink) {
                        EmptyView()
                    }
                }
            }
        }

    }
    
    func deselectFromTeam() {
        for i in teams.filter({$0.teamID == teamID}) {
            if !selectedPokemon.contains(pokemonObserved.pokemon.firstIndex(where: {$0.id == i.pokemonID}) ?? 0) {
                moc.delete(i)
            }
        }
    }
    
    func save(pokemonObserved: pokemonObserver, pokemonIndex: Int, teamID: Int16) {

        
        let pokemonData = pokemonObserved.pokemon[pokemonIndex]
        if !teams.contains(where: {$0.teamID == teamID && $0.pokemonID == pokemonData.id}) {
            let currentTeam = Teams(context: self.moc)
            currentTeam.teamID = teamID //use app storage on button press.
            currentTeam.pokemonID = Int16(pokemonData.id)
            for i in pokemonObserved.pokemon.filter({$0.id == pokemonData.id}) {
                currentTeam.health = Int16(i.hp)
            }
            
            currentTeam.timestamp = Date()
            try? self.moc.save()
        }
    }
    func removeTeam() {
        for i in teams.filter({$0.teamID == teamID}) {
            moc.delete(i)
        }
    }
    func addLevelToOne(teamID: Int16) {
        let currentLevel = Levels(context: self.moc)
        currentLevel.teamID = teamID
        currentLevel.level = 1
        try? self.moc.save()
    }
}

struct SelectTeamView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTeamView(pokemonObserved: pokemonObserver(), movesObserved: movesObserver(), teamID: 1, selectedPokemon: [1,2,3,4], showNavLink: false, navLinkPokemonIndex: 3, tabSelect: .constant(3))
            .preferredColorScheme(.dark)
    }
}
