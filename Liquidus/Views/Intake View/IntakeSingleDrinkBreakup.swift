//
//  IntakeSingleDrinkBreakup.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/10/21.
//

import SwiftUI

struct IntakeSingleDrinkBreakup: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var color: Color
    var drinkType: String
    var selectedTimePeriod: String
    var selectedDay: Date
    var selectedWeek: [Date]
    
    var body: some View {
        
        HStack {
            
            // Rectangle Card
            RectangleCard(color: color)
                .frame(width: 35, height: 35)
            
            // If day...
            if selectedTimePeriod == Constants.selectDay {
                
                VStack(alignment: .leading) {
                    // Drink Name
                    Text(drinkType)
                        .bold()
                    
                    // Consumed Amount & Percent
                    let amount = model.getDrinkTypeAmount(type: drinkType, date: selectedDay)
                    let percent = model.getDrinkTypePercent(type: drinkType, date: selectedDay)
                    
                    Text("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getUnits()) / \(percent*100, specifier: "%.2f")%")
                }
                
            // If week...
            } else if selectedTimePeriod == Constants.selectWeek {
                
                VStack(alignment: .leading) {
                    // Drink Name
                    Text(drinkType)
                        .bold()
                    
                    // Consumed Amount & Percent
                    let amount = model.getDrinkTypeAmount(type: drinkType, week: selectedWeek)
                    let percent = model.getDrinkTypePercent(type: drinkType, week: selectedWeek)
                    
                    Text("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getUnits()) / \(percent*100, specifier: "%.2f")%")
                    
                }
                
            }
            
        }
    }
}