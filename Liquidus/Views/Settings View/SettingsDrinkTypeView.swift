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
    
    @ScaledMetric(relativeTo: .body) var symbolSize = 20
    
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
                            // Color
                            if #available(iOS 14, *) {
                                // if iOS 15, use plaette symbol
                                if #available(iOS 15, *) {
                                    Image("custom.drink.fill-3.0")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: symbolSize, height: symbolSize)
                                        .foregroundColor(model.getDrinkTypeColor(type: type))
                                // if iOS 14, use monochrome symbol
                                } else {
                                    Image("custom.drink.fill-2.0")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: symbolSize, height: symbolSize)
                                        .foregroundColor(model.getDrinkTypeColor(type: type))
                                }
                            // if iOS 13 or older, use a circle
                            } else {
                                Circle()
                                    .foregroundColor(model.getDrinkTypeColor(type: type))
                                    .frame(width: symbolSize, height: symbolSize)
                            }
                            
                            // Type Name
                            Text(type)
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
