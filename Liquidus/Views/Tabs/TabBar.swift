//
//  TabBar.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI
import HealthKit

struct TabBar: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var body: some View {
        
        TabView {
            
            // IntakeView
            IntakeView()
                .tabItem {
                    VStack {
                        Image("custom.drink.fill")
                            .font(.system(size: 25))

                        Text("Intake")
                    }
                }
                .tag(0)
            
            // DataLogsView
            DataLogsView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Logs")
                    }
                }
                .tag(1)
            
            // SettingsView
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                }
                .tag(2)
        }
        .onAppear {
            // If water is enabled...
            if model.drinkData.enabled[Constants.waterKey]! && model.drinkData.healthKitEnabled {
                // If healthStore exists and does app have access...
                if model.healthStore?.healthStore != nil && HKHealthStore.isHealthDataAvailable() {
                    // Get statsCollections
                    model.healthStore!.getHealthKitData { statsCollection in
                        // Retrieve HealthKit data
                        if let statsCollection = statsCollection {
                            model.retrieveFromHealthKit(statsCollection)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
            .environmentObject(DrinkModel())
    }
}
