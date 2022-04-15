//
//  IntakeMultiDrinkBreakup.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/16/21.
//

import SwiftUI

struct IntakeMultiDrinkBreakup: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Namespace private var consumedDrinkNamespace
    
    var selectedTimePeriod: Constants.TimePeriod
    var selectedDay: Date
    var selectedWeek: [Date]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(model.drinkData.drinkTypes) { type in
                // if type is enabled...
                if type.enabled {
                    IntakeSingleDrinkBreakup(color: model.getDrinkTypeColor(type: type), drinkType: type, selectedTimePeriod: selectedTimePeriod, selectedDay: selectedDay, selectedWeek: selectedWeek)
                        .padding(.leading)
                        .accessibilityRotorEntry(id: type.id, in: consumedDrinkNamespace)
                }
            }
        }
        .accessibilityRotor("Consumed Drink Types") {
            ForEach(model.drinkData.drinkTypes) { type in
                if selectedTimePeriod == .daily {
                    if model.getTypeAmountByDay(type: type, date: selectedDay) != 0.0 {
                        AccessibilityRotorEntry(type.name, type.id, in: consumedDrinkNamespace)
                    }
                }
                if selectedTimePeriod == .weekly {
                    if model.getTypeAmountByWeek(type: type, week: selectedWeek) != 0.0 {
                        AccessibilityRotorEntry(type.name, type.id, in: consumedDrinkNamespace)
                    }
                }
            }
        }
    }
}

struct IntakeMultiDrinkBreakup_Previews: PreviewProvider {
    static var previews: some View {
        IntakeMultiDrinkBreakup(selectedTimePeriod: .daily, selectedDay: Date(), selectedWeek: DrinkModel().getWeekRange(date: Date()))
            .environmentObject(DrinkModel())
    }
}
