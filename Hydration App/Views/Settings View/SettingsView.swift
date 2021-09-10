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
                        destination: DailyGoalSettings(),
                        label: {
                            HStack {
                                // Display current daily goal
                                Text("Daily Goal: \(model.drinkData.dailyGoal, specifier: "%.0f") \(model.drinkData.units)")
                                
                                Spacer()
                                
                                // Button label
                                Text("Change")
                                    .foregroundColor(.blue)
                            }
                        })
                    
                }
                
                // MARK: - Unit Settings
                Section(footer: Text("If the unit is changed, all measurements will be converted")) {
                    
                    // Unit Picker
                    Picker("Units", selection: $model.drinkData.units) {
                        Text("Milliliters (mL)")
                            .tag(Constants.milliliters)
                        Text("Ounces (oz)")
                            .tag(Constants.ounces)
                    }
                    // Update model and convert measurements
                    .onChange(of: model.drinkData.units, perform: { value in
                        model.convertMeasurements()
                    })
                }
                
                Section() {
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {
                            // TODO
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
    }
}
