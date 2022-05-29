//
//  TabBar.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI
import HealthKit

struct TabBar: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @State var selectedTab = 0
    
    @State var isLogDrinkViewShowing = false
    
    @State var updateButtons = false
    @State var timePeriod = TimePeriod.daily
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            // IntakeView
            IntakeView(updateButtons: updateButtons, updateTimePicker: timePeriod)
                .tabItem {
                    VStack {
                        Image("custom.drink.fill")
                            .font(.system(size: 25))

                        Text("Intake")
                    }
                }
                .tag(0)
            
            // TrendsView
            TrendsView()
                .tabItem {
                    VStack {
                        Image(systemName: "chart.bar")
                        Text("Trends")
                    }
                }
                .tag(1)
            
            // SettingsView
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                }
                .tag(2)
        }
        .onOpenURL(perform: { url in
            if url == Constants.intakeDailyURL {
                selectedTab = 0
                timePeriod = .daily
            } else if url == Constants.logDrinkDailyURL {
                selectedTab = 0
                timePeriod = .daily
                isLogDrinkViewShowing = true
                updateButtons = true
            } else if url == Constants.intakeWeeklyURL {
                selectedTab = 0
                timePeriod = .weekly
            } else if url == Constants.logDrinkWeeklyURL {
                selectedTab = 0
                timePeriod = .weekly
                isLogDrinkViewShowing = true
                updateButtons = true
            }
        })
        .sheet(isPresented: $isLogDrinkViewShowing, content: {
            // Show LogDrinkView
            LogDrinkView(isPresented: $isLogDrinkViewShowing)
                .environmentObject(model)
                .onDisappear {
                    updateButtons = false
                }

        })
        .onAppear {
            // If water is enabled...
            if self.waterEnabled() && model.drinkData.healthKitEnabled {
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
    
    /**
     Checks if the Water DrinkType is enabled
     - Returns: True if enabled; False if not
     */
    func waterEnabled() -> Bool {
        if let water = model.drinkData.drinkTypes.first {
            return water.enabled
        }
        
        return false
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
            .environmentObject(DrinkModel(test: false, suiteName: nil))
    }
}
