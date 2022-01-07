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
            if model.drinkData.enabled[type]! && !model.grayscaleEnabled {
                // Update color
                Section(header: Text("Color")) {
                    // ColorPicker
                    ColorPicker("Choose a new color", selection: $newColor, supportsOpacity: false)
                }
            }
        }
        .onAppear {
            // On appear update variables based on model
            enabled = model.drinkData.enabled[type]!
            newColor = model.getDrinkTypeColor(type: type)
        }
        .navigationTitle("Edit \(type)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // If type enabled...
                    if model.drinkData.enabled[type]! {
                        // update color in model
                        model.drinkData.colors[type] = CodableColor(color: UIColor(newColor))
                        model.drinkData.colorChanged[type] = true
                    }
                    // Dismiss view
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

struct SettingsEditDefaultTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsEditDefaultTypeView(type: Constants.waterKey)
            .environmentObject(DrinkModel())
    }
}
