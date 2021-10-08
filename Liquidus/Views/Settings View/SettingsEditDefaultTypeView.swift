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
            Section(header: Text("\(model.drinkData.enabled[type]! ? "Disable" : "Enable")")) {
                Toggle("\(enabled ? "Disable" : "Enable") Type", isOn: $enabled)
            }
            
            if model.drinkData.enabled[type]! {
                Section(header: Text("Color")) {
                    ColorPicker("Choose a new color", selection: $newColor, supportsOpacity: false)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if model.drinkData.enabled[type]! {
                                model.drinkData.colors[type] = CodableColor(color: UIColor(newColor))
                            }
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
            enabled = model.drinkData.enabled[type]!
            newColor = model.drinkData.colors[type]!.getColor()
        }
        .onChange(of: enabled, perform: { newValue in
            if enabled {
                model.drinkData.enabled[type] = true
            } else {
                model.drinkData.enabled[type] = false
            }
            model.save()
        })
        .navigationTitle("Edit Drink Type")
        
    }
}

struct SettingsEditDefaultTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsEditDefaultTypeView(type: Constants.waterKey)
            .environmentObject(DrinkModel())
    }
}
