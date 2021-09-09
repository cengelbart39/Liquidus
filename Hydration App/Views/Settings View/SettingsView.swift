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
                
                Section(footer: Text("Weekly goal adjusts accordingly")) {
                    
                    NavigationLink(
                        destination: DailyGoalSettings(),
                        label: {
                            HStack {
                                Text("Daily Goal: \(model.drinkData.dailyGoal, specifier: "%.0f") \(model.drinkData.units)")
                                
                                Spacer()
                                
                                Text("Change")
                                    .foregroundColor(.blue)
                            }
                        })
                    
                }
                
                Section(footer: Text("If the unit is changed, all measurements will be converted")) {
                    
                    Picker("Units", selection: $model.drinkData.units) {
                        Text("Milliliters (mL)")
                            .tag(Constants.milliliters)
                        Text("Ounces (oz)")
                            .tag(Constants.ounces)
                    }
                    .onChange(of: model.drinkData.units, perform: { value in
                        model.convertMeasurements()
                    })
                }
                
                Section() {
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
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
