//
//  DataLogsDrinkBreakup.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/10/21.
//

import SwiftUI

struct DataLogsDrinkBreakup: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var color: Color
    var drinkType: String
    var selectedTimePeriod: String
    
    var body: some View {
        
        HStack {
            
            // Rectangle Card
            RectangleCard(color: color)
                .frame(width: 30, height: 30)
            
            // If day...
            if selectedTimePeriod == Constants.selectDay {
                
                VStack(alignment: .leading) {
                    // Drink Name
                    Text(drinkType)
                    
                    // Consumed Amount & Percent
                    Text("\(model.getDrinkTypeAmount(type: drinkType, date: model.drinkData.selectedDay), specifier: "%.0f") \(model.drinkData.units) / \(model.getDrinkTypePercent(type: drinkType, date: model.drinkData.selectedDay)*100, specifier: "%.2f")%")
                }
                
            // If week...
            } else {
                
                VStack(alignment: .leading) {
                    // Drink Name
                    Text(drinkType)
                    
                    // Consumed Amount & Percent
                    Text("\(model.getDrinkTypeAmount(type: drinkType, week: model.drinkData.selectedWeek), specifier: "%.0f") \(model.drinkData.units) / \(model.getDrinkTypePercent(type: drinkType, week: model.drinkData.selectedWeek)*100, specifier: "%.2f")%")
                    
                }
                
            }
            
        }
    }
}
