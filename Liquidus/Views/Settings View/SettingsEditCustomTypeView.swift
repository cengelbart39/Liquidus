//
//  SettingsEditCustomTypeView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 10/8/21.
//

import SwiftUI

struct SettingsEditCustomTypeView: View {
    
    @EnvironmentObject var model: DrinkModel
    @Environment(\.presentationMode) var presentationMode
    
    var type: String
    var color: Color
    
    @State var newColor = Color.black
    @State var name = ""
    
    var body: some View {
        
        
        Form {
            Section(header: Text("Name")) {
                TextField("", text: $name)
            }
            
            Section(header: Text("Color")) {
                ColorPicker("Choose a new color", selection: $newColor, supportsOpacity: false)
            }
            
            Section {
                HStack {
                    Spacer()
                    
                    Button {
                        model.drinkData.colors[type]! = CodableColor(color: UIColor(newColor))
                        model.editDrinkType(old: type, new: name)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                    }

                    Spacer()
                }
            }
        }
        .onAppear {
            name = type
            newColor = model.drinkData.colors[type]!.getColor()
        }
        .navigationTitle("Edit Drink Type")
    }
    
}

struct EditDrinkTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsEditCustomTypeView(type: Constants.waterKey, color: Color(.systemTeal))
            .environmentObject(DrinkModel())
    }
}
