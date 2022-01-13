//
//  Liquidus_App.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

@main
struct Liquidus_App: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(DrinkModel())
        }
    }
}
