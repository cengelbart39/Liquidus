//
//  SettingsView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @State var dailyGoal = ""
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                // MARK: - Daily Goal Settings
                Section(footer: Text("Weekly goal adjusts accordingly")) {
                    
                    NavigationLink(
                        // Display Settings Page
                        destination: SettingsDailyGoalView(),
                        label: {
                            HStack {
                                // Display current daily goal
                                Text("Daily Goal: \(model.drinkData.dailyGoal, specifier: "%.0f") \(model.getUnits())")
                            }
                        })
                    
                }
                
                // MARK: - Unit Settings
                Section(footer: Text("If the unit is changed, all measurements will be converted")) {
                    
                    NavigationLink(
                        destination: SettingsUnitsView(),
                        label: {
                            Text("\(model.drinkData.units) (\(model.getUnits()))")
                        })
                }
                
                Section() {
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {
                            if let healthStore = model.healthStore {
                                if model.drinkData.lastHKSave == nil {
                                    healthStore.requestAuthorization { succcess in
                                        if succcess {
                                            healthStore.getHealthKitData { statsCollection in
                                                if let statsCollection = statsCollection {
                                                    model.retrieveFromHealthKit(statsCollection)
                                                    model.saveToHealthKit()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }, label: {
                            Text("Sync with Apple Health")
                                .foregroundColor(Color(.systemPink))
                        })
                        
                        Spacer()
                    }
                    
                }
                
                
            }
            .navigationBarTitle("Settings")
        }

        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(DrinkModel())
    }
}
