//
//  IntakeMultiDrinkBreakup.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/16/21.
//

import SwiftUI

struct IntakeMultiDrinkBreakup: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)], predicate: NSPredicate(format: "enabled == true")) var types: FetchedResults<DrinkType>
    
    @EnvironmentObject var model: DrinkModel
    
    @Namespace private var consumedDrinkNamespace
    
    var day: Day
    @Binding var trigger: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(types) { type in
                // if type is enabled...
                IntakeSingleDrinkBreakup(color: model.getDrinkTypeColor(type: type), type: type, day: day, trigger: $trigger)
                    .padding(.leading)
                    .accessibilityRotorEntry(id: type.id, in: consumedDrinkNamespace)
            }
        }
        .accessibilityRotor("Consumed Drink Types") {
            ForEach(types) { type in
                if type.getTypeAmountByDay(day: day) != 0.0 {
                    AccessibilityRotorEntry(type.name, type.id, in: consumedDrinkNamespace)
                }
            }
        }
    }
}
