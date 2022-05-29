//
//  SettingsDrinkTypeView.swift
//  Liquidus
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
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.dynamicTypeSize) var dynamicType
    
    @State var isPresented = false
    
    @State var editButtonId = UUID()
    @State var newDrinkTypeButtonId = UUID()
    
    @ScaledMetric(relativeTo: .body) var symbolSize = 20
    
    var body: some View {
        Form {
            
            // MARK: - Default Drinks
            Section(header: Text("Default")) {
                // Loop through default drinks
                ForEach(model.drinkData.drinkTypes.filter { $0.isDefault }) { type in
                    
                    NavigationLink {
                        // Go to Edit view
                        SettingsEditDefaultTypeView(type: type)
                    } label: {
                        if type.enabled {
                            HStack {
                                Image("custom.drink.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: symbolSize, height: symbolSize)
                                    .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                    .accessibilityHidden(true)
                                
                                // Type Name
                                Text(type.name)
                            }
                            // Show color or grayscale variant if enabled
                            .saturation(type.enabled ? 1 : 0)
                        } else {
                            if dynamicType.isAccessibilitySize {
                                VStack(alignment: .leading) {
                                    
                                    Image("custom.drink.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: symbolSize, height: symbolSize)
                                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                        .accessibilityHidden(true)
                                    
                                    // Type Name
                                    Text(type.name)
                                    // Accessibility Label should only include "Type Disabled"
                                    // when the type is disabled, when Differenitiate without Color
                                    // is disabled, and when the Grayscale Color Filter is disabled
                                        .accessibilityLabel("\(type.name)\((!type.enabled && !differentiateWithoutColor && !model.grayscaleEnabled) ? ", Type Disabled" : "")")
                                    
                                    // Check if Differentiate without Color or Grayscale Color Filter
                                    // is enabled and the type is disabled
                                    if (differentiateWithoutColor || model.grayscaleEnabled) && !type.enabled {
                                        
                                        Text("Disabled")
                                        
                                    }
                                }
                                .saturation(type.enabled ? 1 : 0)
                            } else {
                                HStack {
                                    // Color
                                    Image("custom.drink.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: symbolSize, height: symbolSize)
                                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                        .accessibilityHidden(true)
                                    
                                    // Type Name
                                    Text(type.name)
                                    // Accessibility Label should only include "Type Disabled"
                                    // when the type is disabled, when Differenitiate without Color
                                    // is disabled, and when the Grayscale Color Filter is disabled
                                        .accessibilityLabel("\(type.name)\((!type.enabled && !differentiateWithoutColor && !model.grayscaleEnabled) ? ", Type Disabled" : "")")
                                    
                                    // Check if Differentiate without Color or Grayscale Color Filter
                                    // is enabled and the type is disabled
                                    if (differentiateWithoutColor || model.grayscaleEnabled) && !type.enabled {
                                        
                                        Spacer()
                                        
                                        Text("Disabled")
                                        
                                    }
                                }
                                // Show color or grayscale variant if enabled
                                .saturation(type.enabled ? 1 : 0)
                            }
                        }
                    }
                }
            }
            
            // MARK: - Custom
            Section(header: Text("Custom"), footer: Text("Deleting custom drink types, will delete ALL associated data")) {
                
                CustomDrinkTypeView()
                
            }
        }
        .sheet(isPresented: $isPresented) {
            NewDrinkTypeView(isPresented: $isPresented)
                .environmentObject(model)
                .onDisappear {
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
                .accessibilityLabel("Create New Drink Type")
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    editMode.wrappedValue.toggle()
                } label: {
                    Image(systemName: editMode.wrappedValue == .active ? "pencil.slash" : "pencil")
                }
                .id(editButtonId)
                .accessibilityLabel(editMode.wrappedValue == .active ? "Cancel Edit" : "Edit Custom Drink Types")
            }
        }
        .accessibilityAction(named: "Create New Drink Type") {
            isPresented = true
            editButtonId = UUID()
            newDrinkTypeButtonId = UUID()
        }
        .accessibilityAction(named: "Edit Custom Types") {
            editMode.wrappedValue.toggle()
        }
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
            .environmentObject(DrinkModel(test: false, suiteName: nil))
    }
}
