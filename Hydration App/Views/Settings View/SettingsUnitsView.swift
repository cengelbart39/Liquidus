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
                    // If the units are not mL...
                    if model.drinkData.units != Constants.milliliters {
                        
                        let pastUnit = model.drinkData.units
                        
                        // Change units to mL
                        model.drinkData.units = Constants.milliliters
                        
                        // Convert all measurements
                        model.convertMeasurements(pastUnit: pastUnit, newUnit: Constants.milliliters)
                        
                        // Dismiss screen
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    // Else do nothing
                }, label: {
                    HStack {
                        // Text
                        Text("\(Constants.milliliters) (\(Constants.mL))")
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
                    // If the units are not Fluid Ounces (US)...
                    if model.drinkData.units != Constants.fluidOuncesUS {
                        
                        let pastUnit = model.drinkData.units
                        
                        // Change to oz
                        model.drinkData.units = Constants.fluidOuncesUS
                        
                        // Convert all measurements
                        model.convertMeasurements(pastUnit: pastUnit, newUnit: Constants.fluidOuncesUS)
                        
                        // Dismiss screen
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    HStack {
                        // Text
                        Text("\(Constants.fluidOuncesUS) (\(Constants.flOzUS))")
                            .accentColor(colorScheme == .light ? .black : .white)
                        
                        // If Fluid Ounces (US) are selected
                        if model.drinkData.units == Constants.fluidOuncesUS {
                            
                            Spacer()
                            
                            // Display checkmark1
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                })
                
                Button(action: {
                    // If the units are not Fluid Ounces (Imperial)...
                    if model.drinkData.units != Constants.fluidOuncesIM {
                        
                        let pastUnit = model.drinkData.units
                        
                        // Change to oz
                        model.drinkData.units = Constants.fluidOuncesIM
                        
                        // Convert all measurements
                        model.convertMeasurements(pastUnit: pastUnit, newUnit: Constants.fluidOuncesIM)
                        
                        // Dismiss screen
                        presentationMode.wrappedValue.dismiss()
                    }

                }, label: {
                    HStack {
                        // Text
                        Text("\(Constants.fluidOuncesIM) (\(Constants.flOzIM))")
                            .accentColor(colorScheme == .light ? .black : .white)
                        
                        // If Fluid Ounces (Imperial) are selected
                        if model.drinkData.units == Constants.fluidOuncesIM {
                            
                            Spacer()
                            
                            // Display checkmark
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
