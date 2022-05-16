//
//  CustomDrinkTypeView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct CustomDrinkTypeView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicType
    
    @EnvironmentObject var model: DrinkModel
    
    @ScaledMetric(relativeTo: .body) var symbolSize = 20
        
    var body: some View {
        
        // If there are custom drinks...
        if model.drinkData.drinkTypes.filter({ !$0.isDefault }).count > 0 {
            
            List {
                // Loop through custom drinks
                ForEach(model.drinkData.drinkTypes) { type in
                    
                    if (!type.isDefault) {
                        NavigationLink {
                            // Go to Edit view
                            SettingsEditCustomTypeView(type: type, color: model.getDrinkTypeColor(type: type))
                        } label: {
                            // If Dynamic Type is accessibility xLarge, xxLarge, or xxxLarge...
                            if dynamicType == .accessibility3 || dynamicType == .accessibility4 || dynamicType == .accessibility5 {
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Image("custom.drink.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: symbolSize, height: symbolSize)
                                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                    
                                    // Type Name
                                    Text(type.name)
                                    
                                }
                            } else {
                                HStack {
                                    // Show type color
                                    Image("custom.drink.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: symbolSize, height: symbolSize)
                                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                    
                                    // Type Name
                                    Text(type.name)
                                }
                            }
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
            
    func deleteCustom(at offsets: IndexSet) {
        // Delete drinks of custom drink type
        model.deleteCustomDrinks(atOffsets: offsets)
        
        // Tell views to update
        model.objectWillChange.send()
    }
}
        
struct CustomDrinkTypeDisplay_Previews: PreviewProvider {
    static var previews: some View {
        CustomDrinkTypeView()
            .environmentObject(DrinkModel(test: false, suiteName: nil))
    }
}
