//
//  LeagueBattleView.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/19/21.
//

import SwiftUI

struct LeagueBattleView: View {
    @AppStorage ("currentLevel") var currentLevel = 1
    @AppStorage ("selectedGame") var selectedGame = 0
    
    @ObservedObject var pokemonObserved: pokemonObserver
    @ObservedObject var movesObserved: movesObserver
    @ObservedObject var battlesObserved: battlesObserver
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Levels.teamID, ascending: true)], animation: .default)
    private var levels: FetchedResults<Levels>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BattlesWon.teamID, ascending: true)], animation: .default)
    private var battlesWon: FetchedResults<BattlesWon>

    var body: some View {
        Form {
            Section(header: Text("Training")) {
                NavigationLink(destination: PracticeFighterPicker(pokemonObserved: pokemonObserved, movesObserved: movesObserved)) {
                    HStack {
                        Image(systemName: "doc.text.below.ecg").foregroundColor(.green)
                        Text("Practice with Your Team").foregroundColor(.primary)
                    }
                }
            }
            Section(header: Text("Elite Four")) {
                ForEach(battlesObserved.battles.filter({$0.level == currentLevel && $0.preferredType != .none}).indices) { battleIndex in
                    battleCell(pokemonObserved: pokemonObserved, battlesObserved: battlesObserved, battleIndex: battleIndex)
                }
            }
            Section(header: Text("Champion")) {
                battleCell(pokemonObserved: pokemonObserved, battlesObserved: battlesObserved, battleIndex: battlesObserved.battles.lastIndex(where: {$0.level == currentLevel && $0.preferredType == .none}) ?? (battlesObserved.battles.filter({$0.level == currentLevel}).endIndex - 1) )
            }
        }.navigationTitle("League Battles")
    }
}

struct battleCell: View {
    @AppStorage ("currentLevel") var currentLevel = 1
    @AppStorage ("selectedGame") var selectedGame = 0
    
    @ObservedObject var pokemonObserved: pokemonObserver
    @ObservedObject var battlesObserved: battlesObserver

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BattlesWon.teamID, ascending: true)], animation: .default)
    private var battlesWon: FetchedResults<BattlesWon>
    
    @State var battleIndex: Int
    
    var body: some View {
        let battleData = battlesObserved.battles[battleIndex]
        let battleWon = battlesWon.contains(where: {$0.teamID == selectedGame && $0.level == currentLevel && $0.battleID == battleData.id})
            
        NavigationLink(destination: BattlesPreview(battlesObserved: battlesObserved, pokemonObserved: pokemonObserved)) {
            HStack {
                if battleWon {
                    Image(systemName: "checkmark.circle").foregroundColor(.purple)
                } else if battleData.preferredType == .none {
                    Image(systemName: "rosette").foregroundColor(.red)
                } else {
                    Image(systemName: "star.circle").foregroundColor(.blue)
                }
                
                if battleData.preferredType == .none {
                    Text(battleData.foeName).bold()
                } else {
                    Text(battleData.foeName)
                }
                Spacer()
                TypeView(type: battleData.preferredType, font: .footnote)
            }
        }
    }
}
#warning("when losing a battle, delete all the battles won where the current level and team id equal the docs")

struct LeagueBattleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LeagueBattleView(pokemonObserved: pokemonObserver(), movesObserved: movesObserver(), battlesObserved: battlesObserver())
        }
    }
}
