//
//  SettingsUnitsView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/11/21.
//

import SwiftUI
import WidgetKit

struct SettingsUnitsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var model: DrinkModel
    
    var body: some View {
        
        Form {
            Section(footer: Text("Changing the unit will cause all measurements to be converted")) {
                
                // MARK: - Cups (US)
                Button(action: {
                    // If the units are not Cups (US)...
                    if model.drinkData.units != Constants.cupsUS {
                        
                        let pastUnit = model.drinkData.units
                        
                        // Change to oz
                        model.drinkData.units = Constants.cupsUS
                        
                        // Convert all measurements
                        model.convertMeasurements(pastUnit: pastUnit, newUnit: Constants.cupsUS)
                        
                        // Save model
                        model.save(test: false)
                        
                        // Update widget
                        WidgetCenter.shared.reloadAllTimelines()
                        
                        // Dismiss screen
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    HStack {
                        // Text
                        Text("\(Constants.cupsUS) (\(Constants.cups))")
                            .accentColor(colorScheme == .light ? .black : .white)
                            .accessibilityLabel(Constants.cupsUS)
                        
                        // If Cups (US) are selected
                        if model.drinkData.units == Constants.cupsUS {
                            
                            Spacer()
                            
                            // Display checkmark1
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .accessibilityAddTraits(.isSelected)
                        }
                    }
                })
                .accessibilityElement(children: .combine)
                
                // MARK: - Fluid Ounces (US)
                Button(action: {
                    // If the units are not Fluid Ounces (US)...
                    if model.drinkData.units != Constants.fluidOuncesUS {
                        
                        let pastUnit = model.drinkData.units
                        
                        // Change to oz
                        model.drinkData.units = Constants.fluidOuncesUS
                        
                        // Convert all measurements
                        model.convertMeasurements(pastUnit: pastUnit, newUnit: Constants.fluidOuncesUS)
                        
                        // Save model
                        model.save(test: false)
                        
                        // Update widget
                        WidgetCenter.shared.reloadAllTimelines()
                        
                        // Dismiss screen
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    HStack {
                        // Text
                        Text("\(Constants.fluidOuncesUS) (\(Constants.flOzUS))")
                            .accentColor(colorScheme == .light ? .black : .white)
                            .accessibilityLabel(Constants.fluidOuncesUS)
                        
                        // If Fluid Ounces (US) are selected
                        if model.drinkData.units == Constants.fluidOuncesUS {
                            
                            Spacer()
                            
                            // Display checkmark1
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .accessibilityAddTraits(.isSelected)
                        }
                    }
                })
                .accessibilityElement(children: .combine)
                
                // MARK: - Liters
                Button(action: {
                    // If the units are not Liters...
                    if model.drinkData.units != Constants.liters {
                        
                        let pastUnit = model.drinkData.units
                        
                        // Change to liters
                        model.drinkData.units = Constants.liters
                        
                        // Convert all measurements
                        model.convertMeasurements(pastUnit: pastUnit, newUnit: Constants.liters)
                        
                        // Save model
                        model.save(test: false)
                        
                        // Update widget
                        WidgetCenter.shared.reloadAllTimelines()
                        
                        // Dismiss screen
                        presentationMode.wrappedValue.dismiss()
                    }

                }, label: {
                    HStack {
                        // Text
                        Text("\(Constants.liters) (\(Constants.L))")
                            .accentColor(colorScheme == .light ? .black : .white)
                            .accessibilityLabel(Constants.liters)
                        
                        // If Liters are selected
                        if model.drinkData.units == Constants.liters {
                            
                            Spacer()
                            
                            // Display checkmark
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .accessibilityAddTraits(.isSelected)
                        }
                    }

                })
                .accessibilityElement(children: .combine)
                
                // MARK: - Milliliters
                Button(action: {
                    // If the units are not mL...
                    if model.drinkData.units != Constants.milliliters {
                        
                        let pastUnit = model.drinkData.units
                        
                        // Change units to mL
                        model.drinkData.units = Constants.milliliters
                        
                        // Convert all measurements
                        model.convertMeasurements(pastUnit: pastUnit, newUnit: Constants.milliliters)
                        
                        // Save model
                        model.save(test: false)
                        
                        // Update widget
                        WidgetCenter.shared.reloadAllTimelines()
                        
                        // Dismiss screen
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    // Else do nothing
                }, label: {
                    HStack {
                        // Text
                        Text("\(Constants.milliliters) (\(Constants.mL))")
                            .accentColor(colorScheme == .light ? .black : .white)
                            .accessibilityLabel(Constants.milliliters)
                        
                        // If mL is selected...
                        if model.drinkData.units == Constants.milliliters {
                            Spacer()
                            
                            // Display a checkmark
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .accessibilityAddTraits(.isSelected)
                        }
                    }
                })
                .accessibilityElement(children: .combine)

            }
        }
        .navigationBarTitle("Units")
    }
}

struct SettingsUnitsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsUnitsView()
            .environmentObject(DrinkModel(test: false, suiteName: nil))
    }
}
