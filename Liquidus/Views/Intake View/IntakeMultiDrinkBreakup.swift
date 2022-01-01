//
//  IntakeMultiDrinkBreakup.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/16/21.
//

import SwiftUI

struct IntakeMultiDrinkBreakup: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var selectedTimePeriod: String
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
                }
            }
        }
        
    }
}

struct IntakeMultiDrinkBreakup_Previews: PreviewProvider {
    static var previews: some View {
        IntakeMultiDrinkBreakup(selectedTimePeriod: Constants.selectDay, selectedDay: Date(), selectedWeek: DrinkModel().getWeekRange(date: Date()))
            .environmentObject(DrinkModel())
    }
}
