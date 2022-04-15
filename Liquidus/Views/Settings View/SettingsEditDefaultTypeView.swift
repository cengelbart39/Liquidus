//
//  SettingsEditDefaultTypeView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/8/21.
//

import SwiftUI
import WidgetKit

struct SettingsEditDefaultTypeView: View {
    
    @EnvironmentObject var model: DrinkModel
    @Environment(\.presentationMode) var presentationMode
        
    var type: DrinkType
    
    @State var enabled = true
    @State var newColor = Color.black
        
    var body: some View {
        
        if let index = model.drinkData.drinkTypes.firstIndex(of: type) {
        
            Form {
                // Enable / Disable
                Section(header: Text("\(model.drinkData.drinkTypes[index].enabled ? "Disable" : "Enable")")) {
                    Toggle("\(enabled ? "Disable" : "Enable") Type", isOn: $enabled)
                }
                
                // If type is enabled...
                if enabled && !model.grayscaleEnabled {
                    // Update color
                    Section(header: Text("Color")) {
                        // ColorPicker
                        ColorPicker("Choose a new color", selection: $newColor, supportsOpacity: false)
                            .accessibilityElement()
                            .accessibilityLabel("Change color")
                            .accessibilityAddTraits(.isButton)
                    }
                }
            }
            .onAppear {
                // On appear update variables based on model
                if let index = model.drinkData.drinkTypes.firstIndex(of: type) {
                    enabled = model.drinkData.drinkTypes[index].enabled
                    newColor = model.getDrinkTypeColor(type: type)
                }
            }
            .navigationTitle("Edit \(type.name)")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Update enabled status
                        if let index = model.drinkData.drinkTypes.firstIndex(of: type) {
                            model.drinkData.drinkTypes[index].enabled = enabled
                            
                            // If type enabled...
                            if model.drinkData.drinkTypes[index].enabled {
                                
                                // update color in model
                                model.drinkData.drinkTypes[index].color = CodableColor(color: UIColor(newColor))
                                model.drinkData.drinkTypes[index].colorChanged = true
                            }
                            
                            model.objectWillChange.send()
                        }
                            
                        // Save information
                        model.save()
                        
                        // Update widget
                        WidgetCenter.shared.reloadAllTimelines()
                        
                        // Dismiss view
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
            .accessibilityAction(named: "Save") {
                // Update enabled status
                if let index = model.drinkData.drinkTypes.firstIndex(of: type) {
                    model.drinkData.drinkTypes[index].enabled = enabled
                    
                    if model.drinkData.drinkTypes[index].enabled {
                        model.drinkData.drinkTypes[index].color = CodableColor(color: UIColor(newColor))
                        model.drinkData.drinkTypes[index].colorChanged = true
                    }
                    
                    model.objectWillChange.send()
                }
                
                // Save information
                model.save()
                
                // Update Widget
                WidgetCenter.shared.reloadAllTimelines()
                
                // Dismiss view
                presentationMode.wrappedValue.dismiss()
            }
            
        }
    }
}
