//
//  CustomDrinkTypeDisplay.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct CustomDrinkTypeDisplay: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var body: some View {
        
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
    
    func deleteCustom(at offsets: IndexSet) {
        // Delete drinks of custom drink type
        model.deleteCustomDrinks(atOffsets: offsets)
        
        // Remove drink type from customDrinkTypes
        model.drinkData.customDrinkTypes.remove(atOffsets: offsets)
    }
}

struct CustomDrinkTypeDisplay_Previews: PreviewProvider {
    static var previews: some View {
        CustomDrinkTypeDisplay()
    }
}
