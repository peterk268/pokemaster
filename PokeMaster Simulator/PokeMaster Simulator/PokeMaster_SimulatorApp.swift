//
//  PokeMaster_SimulatorApp.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/5/21.
//

import SwiftUI

@main
struct PokeMaster_SimulatorApp: App {
    let persistenceController = PersistenceController.shared

    @AppStorage ("selectedGame") var selectedGame = 0

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
