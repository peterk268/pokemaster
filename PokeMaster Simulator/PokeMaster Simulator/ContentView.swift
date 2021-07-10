//
//  ContentView.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/5/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
    
    @StateObject var pokemonObserved = pokemonObserver()
    @StateObject var movesObserved = movesObserver()
    @StateObject var battlesObserved = battlesObserver()

    @State var selection = 2
    
    @AppStorage ("selectedGame") var selectedGame = 0
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Teams.timestamp, ascending: true)], animation: .default)
    private var teams: FetchedResults<Teams>

    var body: some View {
        
        TabView(selection: $selection) {
            NavigationView {
                if teams.isEmpty {
                    VStack {
                        Spacer(); Text("Please Create a Team First.").font(.title) ;Spacer() ; Spacer(); Spacer()
                    }
                } else {
                    LeagueBattleView(pokemonObserved: pokemonObserved, movesObserved: movesObserved, battlesObserved: battlesObserved)
                }
            }.tag(1)
            .tabItem {
                Image(systemName: "building.columns")
                Text("Battle")
            }
            
            NavigationView {
                if teams.isEmpty {
                    SelectGameView(pokemonObserved: pokemonObserved, movesObserved: movesObserved, tabSelect: $selection)
                } else {
                    TeamOverview(pokemonObserved: pokemonObserved, movesObserved: movesObserved/*, teamID: Int16(selectedGame)*/, navLink: .constant(false))
                }
            }
            .tag(2)
            .tabItem {
                Image(systemName: "briefcase")
                Text("Team")
            }
            
            NavigationView {
                SettingsView(pokemonObserved: pokemonObserved, movesObserved: movesObserved, tabSelect: $selection)
            }.tag(3)
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
//        List {
//            ForEach(items) { item in
//                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//            }
//            .onDelete(perform: deleteItems)
//        }
//        .toolbar {
//            #if os(iOS)
//            EditButton()
//            #endif
//
//            Button(action: addItem) {
//                Label("Add Item", systemImage: "plus")
//            }
//        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
