//
//  SettingsDrinkTypeView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 10/3/21.
//

import SwiftUI

struct SettingsDrinkTypeView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @State var isPresented = false
    
    var body: some View {
        Form {
            
            // MARK: - Default Drinks
            Section(header: Text("Default")) {
                // Loop through default drinks
                ForEach(model.drinkData.defaultDrinkTypes, id: \.self) { type in
                    
                    NavigationLink {
                        // Go to Edit view
                        SettingsEditDefaultTypeView(type: type)
                    } label: {
                        HStack {
                            // Type Name
                            Text(type)
                            
                            Spacer()
                            
                            // Color
                            if #available(iOS 14, *) {
                                // if iOS 15, use plaette symbol
                                if #available(iOS 15, *) {
                                    Image("custom.drink.fill.inside-3.0")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.primary, model.drinkData.colors[type]!.getColor(), .primary)
                                // if iOS 14, use monochrome symbol
                                } else {
                                    Image("custom.drink.fill-2.0")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(model.drinkData.colors[type]!.getColor())
                                }
                            // if iOS 13 or older, use a circle
                            } else {
                                Circle()
                                    .foregroundColor(model.drinkData.colors[type]!.getColor())
                                    .frame(width: 20, height: 20)
                            }
                        }
                        // Show color or grayscale variant if enabled
                        .saturation(model.drinkData.enabled[type]! ? 1 : 0)
                    }

                }
            }
            
            // MARK: - Custom
            Section(header: Text("Custom"), footer: Text("Deleting custom drink types, will delete ALL associated data")) {
                
                CustomDrinkTypeDisplay()
                
            }
            
            // MARK: - Add Custom Drinks
            Section {
                HStack {
                    
                    Spacer()
                    
                    Button {
                        // Update isPresented
                        isPresented = true
                    } label: {
                        Text("Add Drink Type")
                    }
                    // Show sheet
                    .sheet(isPresented: $isPresented) {
                        NewDrinkTypeView(isPresented: $isPresented)
                            .environmentObject(model)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarTitle("Drink Types")
        .toolbar {
            EditButton()
        }
    }
    
    func deleteCustom(at offsets: IndexSet) {
        // Delete drinks of custom drink type
        model.deleteCustomDrinks(atOffsets: offsets)
        
        // Remove drink type from customDrinkTypes
        model.drinkData.customDrinkTypes.remove(atOffsets: offsets)
    }
}

struct SettingsDrinkTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsDrinkTypeView()
            .preferredColorScheme(.dark)
            .environmentObject(DrinkModel())
    }
}
