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
    
    var body: some View {
        
        let columns = Array(repeating: GridItem(.adaptive(minimum: 200)), count: 2)
        
        LazyVGrid(columns: columns, alignment: .leading) {
            ForEach(model.drinkData.drinkTypes, id: \.self) { type in
                HStack {
                    
                    Spacer()
                    
                    IntakeSingleDrinkBreakup(color: model.drinkData.colors[type]!.getColor(), drinkType: type, selectedTimePeriod: selectedTimePeriod)
                    
                    Spacer()
                }
                
            }
        }
        
    }
}
