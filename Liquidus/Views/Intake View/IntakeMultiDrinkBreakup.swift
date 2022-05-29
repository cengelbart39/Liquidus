//
//  IntakeMultiDrinkBreakup.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/16/21.
//

import SwiftUI

struct IntakeMultiDrinkBreakup: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Namespace private var consumedDrinkNamespace
    
    var day: Day
    @Binding var trigger: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(model.drinkData.drinkTypes) { type in
                // if type is enabled...
                if type.enabled {
                    IntakeSingleDrinkBreakup(color: model.getDrinkTypeColor(type: type), drinkType: type, day: day, trigger: $trigger)
                        .padding(.leading)
                        .accessibilityRotorEntry(id: type.id, in: consumedDrinkNamespace)
                }
            }
        }
        .accessibilityRotor("Consumed Drink Types") {
            ForEach(model.drinkData.drinkTypes) { type in
                if model.getTypeAmountByDay(type: type, day: day) != 0.0 {
                    AccessibilityRotorEntry(type.name, type.id, in: consumedDrinkNamespace)
                }
            }
        }
    }
}
