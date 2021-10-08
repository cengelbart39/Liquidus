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
            Section(header: Text("Default")) {
                ForEach(model.drinkData.defaultDrinkTypes, id: \.self) { type in
                    
                    NavigationLink {
                        SettingsEditDefaultTypeView(type: type)
                    } label: {
                        HStack {
                            Text(type)
                            
                            Spacer()
                            
                            Circle()
                                .foregroundColor(model.drinkData.colors[type]!.getColor())
                                .frame(width: 20, height: 20)
                        }
                        .saturation(model.drinkData.enabled[type]! ? 1 : 0)
                    }

                }
            }
            
            Section(header: Text("Custom"), footer: Text("Deleting custom drink types, will delete ALL associated data")) {
                if model.drinkData.customDrinkTypes.count > 0 {
                    List {
                        ForEach(model.drinkData.customDrinkTypes, id: \.self) { type in
                            
                            NavigationLink {
                                SettingsEditCustomTypeView(type: type, color: model.drinkData.colors[type]!.getColor())
                            } label: {
                                HStack {
                                    Text(type)
                                    
                                    Spacer()
                                    
                                    Circle()
                                        .foregroundColor(model.drinkData.colors[type]!.getColor())
                                        .frame(width: 20, height: 20)
                                }
                            }

                            
                        }
                        .onDelete(perform: deleteCustom)
                    }
                } else {
                    HStack {
                        
                        Spacer()
                        
                        Text("No Custom Drink Types Created")
                            .foregroundColor(Color(.systemGray))
                        
                        Spacer()
                    }
                }
            }
            
            Section {
                HStack {
                    
                    Spacer()
                    
                    Button {
                        isPresented = true
                    } label: {
                        Text("Add Drink Type")
                    }
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
        model.deleteCustomDrinks(atOffsets: offsets)
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
