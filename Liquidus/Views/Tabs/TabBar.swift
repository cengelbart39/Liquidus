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
                        if #available(iOS 14, *) {
                            if #available(iOS 15, *) {
                                Image("custom.drink.fill-3.0")
                                    .resizable()
                                    .font(.title2)
                            } else {
                                Image("custom.drink.fill-2.0")
                                    .resizable()
                                    .font(.title2)
                            }
                        } else {
                            Image(systemName: "drop.fill")
                        }
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
            // Change water color to .cyan on iOS 15
            if model.drinkData.colors[Constants.waterKey]!.getColor() == Color(.systemTeal) {
                if #available(iOS 15, *) {
                    model.drinkData.colors[Constants.waterKey] = CodableColor(color: UIColor(.cyan))
                }
            }
            // If water is enabled...
            if model.drinkData.enabled[Constants.waterKey]! {
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
