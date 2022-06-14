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
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var drinks: FetchedResults<Drink>
    
    @EnvironmentObject var model: DrinkModel
    
    var body: some View {
        
        Form {
            Section(footer: Text("Changing the unit will cause all measurements to be converted")) {
                
                let drinkArray = drinks.map { $0 }
                
                // MARK: - Cups (US)
                Button(action: {
                    // If the units are not Cups (US)...
                    if model.userInfo.units != Constants.cupsUS {
                        
                        let pastUnit = model.userInfo.units
                        
                        // Change to oz
                        model.userInfo.units = Constants.cupsUS

                        // Convert all measurements
                        model.convertMeasurements(pastUnit: pastUnit, newUnit: Constants.cupsUS, drinks: drinkArray)
                        
                        // Save model
                        model.saveUserInfo(test: false)
                        
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
                        if model.userInfo.units == Constants.cupsUS {
                            
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
                    if model.userInfo.units != Constants.fluidOuncesUS {
                        
                        let pastUnit = model.userInfo.units
                        
                        // Change to oz
                        model.userInfo.units = Constants.fluidOuncesUS
                        
                        // Convert all measurements
                        model.convertMeasurements(pastUnit: pastUnit, newUnit: Constants.fluidOuncesUS, drinks: drinkArray)
                        
                        // Save model
                        model.saveUserInfo(test: false)
                        
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
                        if model.userInfo.units == Constants.fluidOuncesUS {
                            
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
                    if model.userInfo.units != Constants.liters {
                        
                        let pastUnit = model.userInfo.units
                        
                        // Change to liters
                        model.userInfo.units = Constants.liters
                        
                        // Convert all measurements
                        model.convertMeasurements(pastUnit: pastUnit, newUnit: Constants.liters, drinks: drinkArray)
                        
                        // Save model
                        model.saveUserInfo(test: false)
                        
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
                        if model.userInfo.units == Constants.liters {
                            
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
                    if model.userInfo.units != Constants.milliliters {
                        
                        let pastUnit = model.userInfo.units
                        
                        // Change units to mL
                        model.userInfo.units = Constants.milliliters
                        
                        // Convert all measurements
                        model.convertMeasurements(pastUnit: pastUnit, newUnit: Constants.milliliters, drinks: drinkArray)
                        
                        // Save model
                        model.saveUserInfo(test: false)
                        
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
                        if model.userInfo.units == Constants.milliliters {
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
