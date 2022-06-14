//
//  CustomDrinkTypeView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct CustomDrinkTypeView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicType
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)], predicate: NSPredicate(format: "isDefault == false")) var types: FetchedResults<DrinkType>
    
    @EnvironmentObject var model: DrinkModel
        
    @ScaledMetric(relativeTo: .body) var symbolSize = 20
        
    var body: some View {
        
        // If there are custom drinks...
        if types.count > 0 {
            
            List {
                // Loop through custom drinks
                ForEach(types) { type in
                    
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
    
    /**
     Remove a Custom Drink Type when deleted by the user
     - Parameter offsets: The index in `model.userInfo.drinkTypes` where the to-be-deleted `DrinkType` is stored
     */
    func deleteCustom(at offsets: IndexSet) {
        let type = types[offsets.first!]
        
        context.delete(type)
        
        PersistenceController.shared.saveContext()
        
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
