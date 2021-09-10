//
//  DrinkBreakup.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct DrinkBreakup: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var color: Color
    var drinkName: String
    var selectedTimePeriod: String
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            RectangleCard(color: color)
            
            VStack(alignment: .leading) {
                
                if selectedTimePeriod == Constants.selectDay {
                    Text(String(format: "%.2f%%", min(model.getDrinkTypePercent(type: drinkName, date: model.drinkData.selectedDay), 1.0)*100.0))
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 8)
                } else {
                    Text(String(format: "%.2f%%", min(model.getDrinkTypePercent(type: drinkName, week: model.drinkData.selectedWeek), 1.0)*100.0))
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 8)
                }
                
                Text(drinkName)
                    .font(.subheadline)
                
                if selectedTimePeriod == Constants.selectDay {
                    Text("\(model.getDrinkTypeAmount(type: drinkName, date: model.drinkData.selectedDay), specifier: "%.0f") \(model.drinkData.units)")
                        .font(.headline)
                } else {
                    Text("\(model.getDrinkTypeAmount(type: drinkName, week: model.drinkData.selectedWeek), specifier: "%.0f") \(model.drinkData.units)")
                        .font(.headline)
                }
                
            }
            .foregroundColor(.white)
            .padding(.leading, 8)
        }
        
    }
}
