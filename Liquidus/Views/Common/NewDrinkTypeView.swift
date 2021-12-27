//
//  NewDrinkTypeView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 10/5/21.
//

import SwiftUI

struct NewDrinkTypeView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Binding var isPresented: Bool
    
    @State var drinkType = ""
    @State var color = Color(red: 0, green: 0, blue: 0)
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                
                ZStack {
                    
                    Rectangle()
                        .foregroundColor(Color(.systemGray6))
                        .ignoresSafeArea()
                    
                    Form {
                        // Change drink type name
                        Section(header: Text("Drink Type")) {
                            TextField("Water", text: $drinkType)
                        }
                        
                        // Change drink type color
                        Section(header: Text("Color"), footer: Text("White and black may not show up well in Light or Dark Mode")) {
                            ColorPicker("Choose a color", selection: $color, supportsOpacity: false)
                        }
                    }
                    .multilineTextAlignment(.leading)
                }
            }
            .navigationTitle("New Drink Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Save new Drink Type
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        model.saveDrinkType(type: drinkType, color: color)
                        isPresented = false
                    } label: {
                        Text("Save")
                    }
                    .disabled(drinkType == "")

                }
                
                // Dismiss sheet
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Cancel")
                    }

                }

            }
        }
    }
}

struct SettingsNewDrinkTypeView_Previews: PreviewProvider {
    static var previews: some View {
        NewDrinkTypeView(isPresented: .constant(true))
    }
}
