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
                            Circle()
                                .foregroundColor(model.drinkData.colors[type]!.getColor())
                                .frame(width: 20, height: 20)
                        }
                        // Show color or grayscale variant if enabled
                        .saturation(model.drinkData.enabled[type]! ? 1 : 0)
                    }

                }
            }
            
            // MARK: - Custom
            Section(header: Text("Custom"), footer: Text("Deleting custom drink types, will delete ALL associated data")) {
                
                // If there are custom drinks...
                if model.drinkData.customDrinkTypes.count > 0 {
                    
                    List {
                        // Loop through custom drinks
                        ForEach(model.drinkData.customDrinkTypes, id: \.self) { type in
                            
                            NavigationLink {
                                // Go to Edit view
                                SettingsEditCustomTypeView(type: type, color: model.drinkData.colors[type]!.getColor())
                            } label: {
                                HStack {
                                    // Type Name
                                    Text(type)
                                    
                                    Spacer()
                                    
                                    // Show type color
                                    Circle()
                                        .foregroundColor(model.drinkData.colors[type]!.getColor())
                                        .frame(width: 20, height: 20)
                                }
                            }

                            
                        }
                        .onDelete(perform: deleteCustom)
                    }
                // If not...
                } else {
                    HStack {
                        
                        Spacer()
                        
                        Text("No Custom Drink Types Created")
                            .foregroundColor(Color(.systemGray))
                        
                        Spacer()
                    }
                }
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
                        SettingsNewDrinkTypeView(isPresented: $isPresented)
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
