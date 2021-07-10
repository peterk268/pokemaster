//
//  SelectGameView.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/5/21.
//

import SwiftUI

struct SelectGameView: View {
    @ObservedObject var pokemonObserved: pokemonObserver
    @ObservedObject var movesObserved: movesObserver
    
    @AppStorage ("selectedGame") var selectedGame = 0
    @AppStorage ("currentLevel") var currentLevel = 1
    
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Teams.teamID, ascending: true)], animation: .default)
    private var teams: FetchedResults<Teams>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Levels.teamID, ascending: true)], animation: .default)
    private var levels: FetchedResults<Levels>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Unlocked.teamID, ascending: true)], animation: .default)
    private var unlocked: FetchedResults<Unlocked>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BattlesWon.teamID, ascending: true)], animation: .default)
    private var battlesWon: FetchedResults<BattlesWon>
        
    @Binding var tabSelect: Int
    
    @State var teamIDs: [Int16] = []
    var body: some View {
        
        Form {
            if !teams.isEmpty {
                
                Section(header: Text("Game Saves")) {
                    ForEach(teamIDs.removingDuplicates(), id: \.self) {i in
//                        NavigationLink(destination: TeamOverview(pokemonObserved: pokemonObserved, movesObserved: movesObserved, teamID: Int16(i), navLink: .constant(false)).onAppear{
//                            selectedGame = Int(i)
//                        })
                        Button(action: {
                            selectedGame = Int(i)
                            currentLevel = Int(levels.filter{$0.teamID == i}.first?.level ?? 1)
                            tabSelect = 2
                            
                        }) {
                            VStack(alignment: .leading) {
                                Text("Game ") + Text("\(i)").bold()
                                
//                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .leading) {
//                                    ForEach(teams.filter({$0.teamID == i})) { j in
//                                        ForEach(pokemonObserved.pokemon.filter({$0.id == j.pokemonID})) { k in
//                                            Text(k.pokemonName).font(.caption2).foregroundColor(.secondary).bold()
//                                        }
//                                    }
//                                }
                            }
                        }

                    }.onDelete(perform: deleteItems)
                }
            }

            Section {
                NavigationLink(destination: SelectTeamView(pokemonObserved: pokemonObserved, movesObserved: movesObserved, teamID: (self.teams.sorted(by: {$0.teamID < $1.teamID}).last?.teamID ?? 0) + 1, tabSelect: $tabSelect)) {
                    HStack {
                        Image(systemName: "plus.circle").foregroundColor(.blue)
                        Text("Create a New Game").bold().foregroundColor(.blue)
                    }
                }
            }
            
        }.navigationTitle("Select a Save File")
        .onAppear {
            for i in teams {
                teamIDs.append(i.teamID)
            }
        }
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let teamID = teams[index].teamID
                for indices in teams.filter({$0.teamID == teamID}).indices {
                    moc.delete(teams[indices])

                }
                for indices in levels.filter({$0.teamID == teamID}).indices {
                    moc.delete(levels[indices])
                }
                for indices in unlocked.filter({$0.teamID == teamID}).indices {
                    moc.delete(unlocked[indices])
                }
                for indices in battlesWon.filter({$0.teamID == teamID}).indices {
                    moc.delete(battlesWon[indices])
                }
            }

            do {
                try moc.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            teamIDs.removeAll()
            for i in teams {
                teamIDs.append(i.teamID)
            }
        }
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}



struct SelectGameView_Previews: PreviewProvider {
    static var previews: some View {
        SelectGameView(pokemonObserved: pokemonObserver(), movesObserved: movesObserver(), tabSelect: .constant(2))
    }
}
