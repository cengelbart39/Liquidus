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
            
            IntakeView()
                .tabItem {
                    VStack {
                        Image(systemName: "drop.fill")
                        Text("Intake")
                    }
                }
                .tag(0)
            
            DataLogsView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Logs")
                    }
                }
                .tag(1)
            
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
            if model.drinkData.enabled[Constants.waterKey]! {
                if model.healthStore?.healthStore != nil && HKHealthStore.isHealthDataAvailable() {
                    model.healthStore!.getHealthKitData { statsCollection in
                        if let statsCollection = statsCollection {
                            model.retrieveFromHealthKit(statsCollection)
                        }
                    }
                }
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
