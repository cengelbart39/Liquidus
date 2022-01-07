//
//  SettingsDrinkTypeView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 10/3/21.
//
//  Custom edit button code from backslash-f and Joannes
//  https://stackoverflow.com/a/57344365
//  

import SwiftUI

struct SettingsDrinkTypeView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.editMode) private var editMode: Binding<EditMode>!
    
    @State var isPresented = false    
    
    @State var backButtonId = UUID()
    @State var editButtonId = UUID()
    @State var newDrinkTypeButtonId = UUID()
    
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
                                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                // if iOS 14, use monochrome symbol
                                } else {
                                    Image("custom.drink.fill-2.0")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: symbolSize, height: symbolSize)
                                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                }
                            // if iOS 13 or older, use a circle
                            } else {
                                Circle()
                                    .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
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
        }
        .sheet(isPresented: $isPresented) {
            NewDrinkTypeView(isPresented: $isPresented)
                .environmentObject(model)
                .onDisappear {
                    backButtonId = UUID()
                    editButtonId = UUID()
                    newDrinkTypeButtonId = UUID()
                }
        }
        .navigationBarTitle("Drink Types")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Update isPresented
                    isPresented = true
                } label: {
                    Image(systemName: "plus")
                }
                .id(newDrinkTypeButtonId)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    editMode.wrappedValue.toggle()
                } label: {
                    Image(systemName: editMode.wrappedValue == .active ? "pencil.slash" : "pencil")
                }
                .id(editButtonId)
            }
        }
    }
    
    func deleteCustom(at offsets: IndexSet) {
        // Delete drinks of custom drink type
        model.deleteCustomDrinks(atOffsets: offsets)
        
        // Remove drink type from customDrinkTypes
        model.drinkData.customDrinkTypes.remove(atOffsets: offsets)
    }
}

extension EditMode {
    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}

struct SettingsDrinkTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsDrinkTypeView()
            .preferredColorScheme(.dark)
            .environmentObject(DrinkModel())
    }
}
