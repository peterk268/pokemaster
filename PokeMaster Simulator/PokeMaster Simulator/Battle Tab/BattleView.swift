//
//  BattleView.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/20/21.
//

import SwiftUI

struct BattleView: View {
    @ObservedObject var pokemonObserved: pokemonObserver
    @ObservedObject var movesObserved: movesObserver
    
    //core data variables
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Teams.timestamp, ascending: true)], animation: .default)
    private var teams: FetchedResults<Teams>
    
    @State var fighterIndex: Int
    @State var foeIndex: Int
    
    @State var fighterHealth: Int
    @State var foeHealth: Int
    
    @State var nextMoveReady = true
    
    @StateObject var dialogeBoxVm: dialogeBoxVM = dialogeBoxVM()
    
    enum alert: Identifiable {
           case practiceLost, practiceWon

           var id: Int {
               self.hashValue
           }
    }
    @State var presentAlert: alert?
    @State var presentHelp = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer().frame(height: 5)
                dialogueBox(vm: dialogeBoxVm)
                HStack {
                    Spacer()
                    PokemonSmallCard(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonIndex: foeIndex, forWhat: "foe", health: $foeHealth, geo: geo, geoDivide: 2).disabled(true)
                    Spacer().frame(width: 10)
                }
                HStack {
                    Spacer().frame(width: 10)
                    #warning("if practice use fighter health else use core data.")
                    PokemonSmallCard(pokemonObserved: pokemonObserved, movesObserved: movesObserved, pokemonIndex: fighterIndex, forWhat: "foe", health: $fighterHealth, geo: geo, geoDivide: 2).disabled(true)
                    Spacer()
                }
                
                Section(header:
                            HStack {
                                Spacer().frame(width: 10)
                                Text("💥 MOVES").foregroundColor(.secondary).font(.footnote)
                                Spacer()
                            }) {
                    #warning("this can fix the stuttering of the view when dialoge box breaks a line with big fonts.")
//                    ScrollView(.vertical) {
                    HStack {
                        Spacer().frame(width: 15)
                        GroupBox {
                            ScrollView(.vertical) {
                                ForEach(pokemonObserved.pokemon[fighterIndex].moves, id: \.self) { move in
                                    Button(action: {
                                        fighterMove(movesObserved: movesObserved, move: move)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            foeMove()
                                        }
                                    }) {
                                        moveBox(movesObserved: movesObserved, moveID: move)
                                    }.disabled(fighterHealth|foeHealth <= 0 || !nextMoveReady)
                                }
                            }
                        }.clipShape(RoundedRectangle(cornerRadius: 25))
                        Spacer().frame(width: 15)
                    }
//                    }
                }
                Spacer().frame(height: 5)

            }
            .onChange(of: foeHealth, perform: { newValue in
                if newValue <= 0 {
                    presentAlert = .practiceWon
                }
            })
            .onChange(of: fighterHealth, perform: { newValue in
                if newValue <= 0 {
                    presentAlert = .practiceLost
                }
            })
            .sheet(isPresented: $presentHelp) {
                NavigationView {
                    HelpView(pokemonData: pokemonObserved.pokemon[foeIndex])
                }
            }
            .alert(item: $presentAlert, content: { item in
                switch item {
                case .practiceWon:
                    return Alert(title: Text("You Won!"),
                                 primaryButton: .default(Text("Play Again"), action: resetBattle),
                                 secondaryButton: .cancel(Text("Dismiss"), action: {
                                    presentationMode.wrappedValue.dismiss()
                                    presentationMode.wrappedValue.dismiss()
                                 }))
                case .practiceLost:
                    return Alert(title: Text("You Lost..."),
                                 primaryButton: .default(Text("Try Again"), action: resetBattle),
                                 secondaryButton: .cancel(Text("Dismiss"), action: {
                                    presentationMode.wrappedValue.dismiss()
                                    presentationMode.wrappedValue.dismiss()
                                 }))
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {presentHelp.toggle()}) {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("Battle", displayMode: .inline)
        }
    }
    func resetBattle() {
        fighterHealth = pokemonObserved.pokemon[fighterIndex].hp
        foeHealth = pokemonObserved.pokemon[foeIndex].hp
        nextMoveReady = true
    }
    func updateDialogeBox(pokemonData: pokemonModel?, moveData: moveModel?, effectiveMultiplier: Float){
        
        dialogeBoxVm.pokemonName = pokemonData?.pokemonName ?? ""
        dialogeBoxVm.pokemonType = pokemonData?.type
        dialogeBoxVm.pokemonMove = moveData?.moveName ?? ""
        dialogeBoxVm.moveType = moveData?.moveType
        dialogeBoxVm.effectiveness = effectiveMultiplier == 2.0 ? .superEffective : effectiveMultiplier == 0.5 ? .notEffective : .normal
        
    }
    func fighterMove(movesObserved: movesObserver, move: Int) {
        nextMoveReady = false
        let moveData = movesObserved.moves.filter({$0.id == move}).first
        let typeMultiplier = typeMultiplier(attackerMoveType: moveData?.moveType, defenderType: pokemonObserved.pokemon[foeIndex].type)
        let recalculatedMoveDamage = Float(moveData?.moveDamage ?? 0) * typeMultiplier
        let roundedMoveDamage = Int(recalculatedMoveDamage.rounded())

        updateDialogeBox(pokemonData: pokemonObserved.pokemon[fighterIndex], moveData: moveData, effectiveMultiplier: typeMultiplier)
        
        foeHealth -= roundedMoveDamage
    }
    func foeMove(){
        if foeHealth > 0 {
            let randomNumber = Int.random(in: 0 ... 3)
            let foeData = pokemonObserved.pokemon[foeIndex]
            let selectedMoveID = foeData.moves[randomNumber]
            let moveData = movesObserved.moves.filter({$0.id == selectedMoveID}).first
            let typeMultiplier = typeMultiplier(attackerMoveType: moveData?.moveType, defenderType: pokemonObserved.pokemon[fighterIndex].type)
            let recalculatedMoveDamage = Float(moveData?.moveDamage ?? 0) * typeMultiplier
            let roundedMoveDamage = Int(recalculatedMoveDamage.rounded())
            
            updateDialogeBox(pokemonData: pokemonObserved.pokemon[foeIndex], moveData: moveData, effectiveMultiplier: typeMultiplier)
            
            fighterHealth -= roundedMoveDamage
            
            nextMoveReady = true
        }
    }
    func typeMultiplier(attackerMoveType: types?, defenderType: types?) -> Float {
        if strengths(type: attackerMoveType).contains(defenderType ?? .normal) {
            return 2.0
        }
        else if weaknesses(type: attackerMoveType).contains(defenderType ?? .normal) {
            return 0.5
        }
        else {
            return 1.0
        }
    }
}

enum effectiveness: Identifiable {
       case superEffective, notEffective, normal

       var id: Int {
           self.hashValue
       }
}
class dialogeBoxVM: ObservableObject {
    @Published var pokemonName: String = ""
    @Published var pokemonType: types? = .normal
    @Published var pokemonMove: String = ""
    @Published var moveType: types? = .normal
    @Published var effectiveness: effectiveness = .normal
}

struct dialogueBox: View {
    @ObservedObject var vm: dialogeBoxVM
    var body: some View {
        GroupBox {
            Group {
                textView
            }.font(.footnote)
        }
    }
    var textView: Text {
        let effectivenessColor: Color = vm.effectiveness == .superEffective ? .red : vm.effectiveness == .notEffective ? .secondary : .primary
        let effectivenessWording: String = vm.effectiveness == .superEffective ? "super effective" : vm.effectiveness == .notEffective ? "not effective" : ""
        let andWas: String = vm.effectiveness == .normal ? "" : " and it was "
        
        if vm.pokemonName == "" {
            return Text("Select a Move.").bold()
        } else {
            return Text(vm.pokemonName).foregroundColor(typeColor(type: vm.pokemonType))
            + Text(" used ")
            + Text(vm.pokemonMove).foregroundColor(typeColor(type: vm.moveType)).bold()
            + Text(andWas)
            + Text(effectivenessWording).foregroundColor(effectivenessColor)
        }
    }
}

struct moveBox: View {
    @ObservedObject var movesObserved: movesObserver
    var moveID: Int
    
    var body: some View {
        let moveData = movesObserved.moves.filter({$0.id == moveID}).first
        GroupBox {
            VStack(spacing: 0) {
                HStack {
                    Text(moveData?.moveName ?? "Error").bold().font(.subheadline).foregroundColor(typeColor(type: moveData?.moveType ?? .none))
                    Spacer()
                    Text(moveData?.emoji ?? "❌").font(.subheadline)
                }
                HStack {
                    TypeView(type: moveData?.moveType ?? .none, font: .caption2)
                    Spacer()

                    Text("\(moveData?.moveDamage ?? 0) DMG").font(.caption2).foregroundColor(.red)
                    Text("\(moveData?.pp ?? 0)/\(moveData?.pp ?? 0)PP").foregroundColor(.secondary).font(.caption2)
                }
            }

        }
    }
}

struct BattleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BattleView(pokemonObserved: pokemonObserver(), movesObserved: movesObserver(), fighterIndex: 3, foeIndex: 47, fighterHealth: 400, foeHealth: 400)
        }
    }
}
