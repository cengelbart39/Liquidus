//
//  SettingsEditDefaultTypeView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/8/21.
//

import SwiftUI

struct SettingsEditDefaultTypeView: View {
    
    @EnvironmentObject var model: DrinkModel
    @Environment(\.presentationMode) var presentationMode
    
    var type: String
    
    @State var enabled = true
    
    @State var newColor = Color.black
    
    var body: some View {
        
        Form {
            // Enable / Disable
            Section(header: Text("\(model.drinkData.enabled[type]! ? "Disable" : "Enable")")) {
                Toggle("\(enabled ? "Disable" : "Enable") Type", isOn: $enabled)
            }
            
            // If type is enabled...
            if model.drinkData.enabled[type]! {
                // Update color
                Section(header: Text("Color")) {
                    // ColorPicker
                    ColorPicker("Choose a new color", selection: $newColor, supportsOpacity: false)
                    
                    // Save Button
                    HStack {
                        Spacer()
                        
                        Button {
                            // If type enabled...
                            if model.drinkData.enabled[type]! {
                                // update color in model
                                model.drinkData.colors[type] = CodableColor(color: UIColor(newColor))
                            }
                            // Dismiss view
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Text("Save")
                        }

                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            // On appear update variables based on model
            enabled = model.drinkData.enabled[type]!
            newColor = model.drinkData.colors[type]!.getColor()
        }
        .onChange(of: enabled, perform: { newValue in
            // If type is enabled update model
            if enabled {
                model.drinkData.enabled[type] = true
            // If type is disabled update model
            } else {
                model.drinkData.enabled[type] = false
            }
            // Save model
            model.save()
        })
        .navigationTitle("Edit \(type)")
        
    }
}

struct SettingsEditDefaultTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsEditDefaultTypeView(type: Constants.waterKey)
            .environmentObject(DrinkModel())
    }
}
