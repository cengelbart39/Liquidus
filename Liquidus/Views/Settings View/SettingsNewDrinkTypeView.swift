//
//  SettingsNewDrinkTypeView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 10/5/21.
//

import SwiftUI

struct SettingsNewDrinkTypeView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Binding var isPresented: Bool
    
    @State var drinkType = ""
    @State var color = Color(red: 0, green: 0, blue: 0)
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ZStack {
                
                Rectangle()
                    .foregroundColor(Color(.systemGray6))
                    .ignoresSafeArea()
                
                VStack {
            
                    // Title
                    HStack {
                        Text("New Drink Type")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top, 50)
                            .padding(.leading, 30)
                        
                        Spacer()
                    }
            
                    Form {
                        // Change drink type name
                        Section(header: Text("Drink Type")) {
                            TextField("Water", text: $drinkType)
                        }
                        
                        // Change drink type color
                        Section(header: Text("Color"), footer: Text("White and black may not show up well in Light or Dark Mode")) {
                            ColorPicker("Choose a color", selection: $color, supportsOpacity: false)
                        }
                        
                        // Save drinkType details
                        Section {
                            HStack {
                                Spacer()
                                
                                Button {
                                    model.saveDrinkType(type: drinkType, color: color)
                                    isPresented = false
                                } label: {
                                    Text("Save")
                                        .foregroundColor(.blue)
                                }

                                
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        
        
    }
}

struct SettingsNewDrinkTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsNewDrinkTypeView(isPresented: .constant(true))
    }
}
