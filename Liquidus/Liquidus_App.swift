//
//  Liquidus_App.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

@main
struct Liquidus_App: App {
    
    let context = PersistenceController.shared.container.viewContext
        
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environment(\.managedObjectContext, context)
                .environmentObject(DrinkModel(test: false, suiteName: nil))
        }
    }
}
