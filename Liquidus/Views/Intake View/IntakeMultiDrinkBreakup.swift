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
        
        // Get all drink types
        let drinkTypes = model.drinkData.defaultDrinkTypes + model.drinkData.customDrinkTypes
        
        VStack(alignment: .leading) {
            ForEach(drinkTypes, id: \.self) { type in
                // if type is enabled...
                if model.drinkData.enabled[type]! {
                    IntakeSingleDrinkBreakup(color: model.getDrinkTypeColor(type: type), drinkType: type, selectedTimePeriod: selectedTimePeriod, selectedDay: selectedDay, selectedWeek: selectedWeek)
                        .padding(.leading)
                        .accessibilityRotorEntry(id: type.self, in: consumedDrinkNamespace)
                }
            }
        }
        .accessibilityRotor("Consumed Drink Types") {
            ForEach(model.drinkData.defaultDrinkTypes+model.drinkData.customDrinkTypes, id: \.self) { type in
                if selectedTimePeriod == .daily {
                    if model.getTypeAmountByDay(type: type, date: selectedDay) != 0.0 {
                        AccessibilityRotorEntry(type, type.self, in: consumedDrinkNamespace)
                    }
                }
                if selectedTimePeriod == .weekly {
                    if model.getTypeAmountByWeek(type: type, week: selectedWeek) != 0.0 {
                        AccessibilityRotorEntry(type, type.self, in: consumedDrinkNamespace)
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
