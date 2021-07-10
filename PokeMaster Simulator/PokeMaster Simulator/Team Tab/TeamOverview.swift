//
//  TeamOverview.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/12/21.
//

import SwiftUI

struct TeamOverview: View {
    @ObservedObject var pokemonObserved: pokemonObserver
    @ObservedObject var movesObserved: movesObserver
    @AppStorage ("selectedGame") var teamID = 0
//    @State var teamID: Int16

    @Binding var navLink: Bool
    
    //core data variables
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Teams.timestamp, ascending: true)], animation: .default)
    private var teams: FetchedResults<Teams>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Unlocked.teamID, ascending: true)], animation: .default)
    private var unlocked: FetchedResults<Unlocked>
    
    @State var showTeamSheet = false
    
    @State var selectedPokemon: [Int] = []
    
    var basePokemon = [1,2,3,4,5,8]
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Section(header: HStack{
                        Spacer().frame(width: 10); Text("PARTY").font(.footnote).foregroundColor(.secondary) ; Spacer()
                    }) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, content: {
                            ForEach(pokemonObserved.pokemon.indices) { pokemonIndex in
                                if teams.filter({$0.teamID == teamID}).contains(where: {$0.pokemonID == pokemonObserved.pokemon[pokemonIndex].id}) {
                                    PokemonSmallCard(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonIndex: pokemonIndex, forWhat: "fighter", health: .constant(0), geo: geo, geoDivide: 3)
                                }
                            }
                        })
                    }
                    Spacer().frame(height: 12)
                    Divider()
                    Spacer().frame(height: 12)

                    HStack {
                        Spacer().frame(width: 10)
                        DisclosureGroup {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, content: {
                                ForEach(pokemonObserved.pokemon.indices) { pokemonIndex in
                                    if !teams.filter({$0.teamID == teamID}).contains(where: {$0.pokemonID == pokemonObserved.pokemon[pokemonIndex].id}) {
                                        if unlocked.contains(where: {$0.teamID == teamID && $0.pokemonID == pokemonObserved.pokemon[pokemonIndex].id}) || basePokemon.contains(pokemonObserved.pokemon[pokemonIndex].id){
                                            PokemonSmallCard(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonIndex: pokemonIndex, forWhat: "fighter", health: .constant(0), geo: geo, geoDivide: 3)
                                        }
                                    }
                                }
                            })
                        } label: {
                            Text("PC STORAGE").font(.footnote).foregroundColor(.secondary)
                        }
                        Spacer().frame(width: 10)
                    }

                    Spacer().frame(height: 20)
                }
            }.navigationTitle("Team Overview")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("heal pokemon")
                        
                        for i in teams.filter({$0.teamID == teamID}) {
                            for j in pokemonObserved.pokemon.filter({$0.id == Int(i.pokemonID)}) {
                                i.health = Int16(j.hp)
                            }
                        }
                        try? moc.save()
                    }) {
                        HStack {
                            Image(systemName: "cross.circle.fill").renderingMode(.original)
                            Text("")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showTeamSheet = true
                        selectedPokemon.removeAll()
                        for index in pokemonObserved.pokemon.indices {
                            if teams.filter({$0.teamID == teamID}).contains(where: {$0.pokemonID == pokemonObserved.pokemon[index].id}) {
                                selectedPokemon.append(index)
                            }
                        }
                    }) {
                        Image(systemName: "arrow.left.arrow.right.circle")
                    }
                }
            }
            .sheet(isPresented: $showTeamSheet) {
                NavigationView {
                    SelectTeamView(pokemonObserved: pokemonObserved, movesObserved: movesObserved, teamID: Int16(teamID), selectedPokemon: selectedPokemon, tabSelect: .constant(2))
                        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                }
            }
        }
    }
}

//trash
//                                    GroupBox {
//                                        NavigationLink(destination: PokemonInfoCard(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonID: Int(i.pokemonID), selectedPokemon: .constant([Int(i.pokemonID)]), showNavLink: .constant(false), forWhat: .constant("info"), forWhatSelectButton: .constant("not used"))) {
//                                            VStack(alignment: .leading, spacing: 0) {
//                                                Text(j.pokemonName).foregroundColor(typeColor(type: j.type)).bold()
//
//                                                ProgressView("", value: Float(i.health), total: Float(j.hp)).frame(width: geo.size.width/3)
//                                                    .padding(.top, -10)
//                                                    .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
//                                                Text("\(i.health)/\(j.hp)HP").font(.caption2).foregroundColor(.secondary).bold()
//                                            }
//                                        }
//                                    }

struct TeamOverview_Previews: PreviewProvider {
    static var previews: some View {
        TeamOverview(pokemonObserved: pokemonObserver(), movesObserved: movesObserver(), teamID: 1, navLink: .constant(false))
    }
}
