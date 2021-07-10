//
//  HelpView.swift
//  PokeMaster Simulator
//
//  Created by Peter Khouly on 6/28/21.
//

import SwiftUI

struct HelpView: View {
    @State var pokemonData: pokemonModel
    @State var column = [GridItem(.flexible())]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            StrWeakView(column: column, type: pokemonData.type)
        }.navigationTitle("Summary of \(pokemonData.pokemonName)")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {presentationMode.wrappedValue.dismiss()}) {
                    Text("Done")
                }
            }
        }
    }
}

//trash
//var strenghText: Text {
//    Text("Because ")
//        + Text("MuTwo").foregroundColor(typeColor(type: .psychic))
//        + Text(" is a ")
//        + Text(TypeView(type: .psychic, font: .body).typeText()).foregroundColor(typeColor(type: .psychic)).bold()
//        + Text(" type, using a ")
//        + Text(TypeView(type: .ghost, font: .body).typeText()).bold()
//        + Text(" or ")
//        + Text("type can help a lot in this battle.")
//}
//var weaknessText: Text {
//    Text("You will also want to avoid using a ")
//        + Text(TypeView(type: .flying, font: .body).typeText()).foregroundColor(typeColor(type: .flying)).bold()
//        + Text(" or ")
//        + Text(TypeView(type: .fighting, font: .body).typeText()).foregroundColor(typeColor(type: .fighting)).bold()
//        + Text(" or ")
//        + Text(TypeView(type: .ghost, font: .body).typeText()).foregroundColor(typeColor(type: .ghost)).bold()
//        + Text(" type as ")
//        + Text(TypeView(type: .psychic, font: .body).typeText()).foregroundColor(typeColor(type: .psychic)).bold()
//        + Text(" type moves can do a lot of damage to them.")
//}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(pokemonData: pokemonModel(id: 4, pokemonName: "Pulsio", type: .fighting, hp: 400, moves: [1,2,3,4]))
    }
}
