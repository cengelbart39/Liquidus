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
        
        let columns = Array(repeating: GridItem(.adaptive(minimum: 200)), count: 2)
        
        let drinkTypes = model.drinkData.defaultDrinkTypes + model.drinkData.customDrinkTypes
        
        LazyVGrid(columns: columns, alignment: .leading) {
            
            ForEach(drinkTypes, id: \.self) { type in
                if model.drinkData.enabled[type]! {
                    HStack {
                        
                        Spacer()
                        
                        IntakeSingleDrinkBreakup(color: model.drinkData.colors[type]!.getColor(), drinkType: type, selectedTimePeriod: selectedTimePeriod, selectedDay: selectedDay, selectedWeek: selectedWeek)
                        
                        Spacer()
                    }
                }
                
            }
        }
        
    }
}
