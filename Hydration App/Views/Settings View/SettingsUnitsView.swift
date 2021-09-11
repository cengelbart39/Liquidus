//
//  SettingsUnitsView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/11/21.
//

import SwiftUI

struct SettingsUnitsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var model: DrinkModel
    
    var body: some View {
        
        Form {
            Section {
                
                Button(action: {
                    // If the units aren't already mL...
                    if model.drinkData.units != Constants.milliliters {
                        
                        // Change units to mL
                        model.drinkData.units = Constants.milliliters
                        
                        // Convert all measurements
                        model.convertMeasurements()
                        
                        // Dismiss screen
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    // Else do nothing
                }, label: {
                    HStack {
                        // Text
                        Text("Milliliters (mL)")
                            .accentColor(colorScheme == .light ? .black : .white)
                        
                        // If mL is selected...
                        if model.drinkData.units == Constants.milliliters {
                            Spacer()
                            
                            // Display a checkmark
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                })
                
                Button(action: {
                    // If the units are mL...
                    if model.drinkData.units != Constants.ounces {
                        
                        // Change to oz
                        model.drinkData.units = Constants.ounces
                        
                        // Convert all measurements
                        model.convertMeasurements()
                        
                        // Dismiss screen
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    HStack {
                        // Text
                        Text("Ounces (oz)")
                            .accentColor(colorScheme == .light ? .black : .white)
                        
                        // If oz are selected
                        if model.drinkData.units == Constants.ounces {
                            
                            Spacer()
                            
                            // Display checkmark1
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                })
                
            }
        }
        .navigationBarTitle("Unit Settings")
    }
}

struct SettingsUnitsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsUnitsView()
            .environmentObject(DrinkModel())
    }
}
