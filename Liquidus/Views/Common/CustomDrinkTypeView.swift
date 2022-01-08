//
//  CustomDrinkTypeView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct CustomDrinkTypeView: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    
    @EnvironmentObject var model: DrinkModel
    
    @ScaledMetric(relativeTo: .body) var symbolSize = 20
        
    var body: some View {
        
        // If there are custom drinks...
        if model.drinkData.customDrinkTypes.count > 0 {
            
            List {
                // Loop through custom drinks
                ForEach(model.drinkData.customDrinkTypes, id: \.self) { type in
                    
                    NavigationLink {
                        // Go to Edit view
                        SettingsEditCustomTypeView(type: type, color: model.getDrinkTypeColor(type: type))
                    } label: {
                        // If Dynamic Type is accessibility xLarge, xxLarge, or xxxLarge...
                        if sizeCategory == .accessibilityExtraLarge || sizeCategory == .accessibilityExtraExtraLarge || sizeCategory == .accessibilityExtraExtraExtraLarge {
                            
                            VStack(alignment: .leading, spacing: 10) {
                                // Show type color
                                if #available(iOS 14, *) {
                                    
                                    if #available(iOS 15, *) {
                                        Image("custom.drink.fill-3.0")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: symbolSize, height: symbolSize)
                                            .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                    } else {
                                        Image("custom.drink.fill-2.0")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: symbolSize, height: symbolSize)
                                            .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                    }
                                } else {
                                    Circle()
                                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                        .frame(width: symbolSize, height: symbolSize)
                                }
                                
                                // Type Name
                                Text(type)
                                
                            }
                        } else {
                            HStack {
                                // Show type color
                                if #available(iOS 14, *) {
                                    
                                    if #available(iOS 15, *) {
                                        Image("custom.drink.fill-3.0")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: symbolSize, height: symbolSize)
                                            .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                    } else {
                                        Image("custom.drink.fill-2.0")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: symbolSize, height: symbolSize)
                                            .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                    }
                                } else {
                                    Circle()
                                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                        .frame(width: symbolSize, height: symbolSize)
                                }
                                
                                // Type Name
                                Text(type)
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
        
        // Remove drink type from customDrinkTypes
        model.drinkData.customDrinkTypes.remove(atOffsets: offsets)
    }
}
        
struct CustomDrinkTypeDisplay_Previews: PreviewProvider {
    static var previews: some View {
        CustomDrinkTypeView()
            .environmentObject(DrinkModel())
    }
}
