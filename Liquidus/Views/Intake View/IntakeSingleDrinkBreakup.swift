//
//  IntakeSingleDrinkBreakup.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/10/21.
//

import SwiftUI

struct IntakeSingleDrinkBreakup: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var color: Color
    var drinkType: String
    var selectedTimePeriod: String
    var selectedDay: Date
    var selectedWeek: [Date]
        
    @ScaledMetric(relativeTo: .body) var symbolSize = 35
    
    var body: some View {
        
        HStack {
            
            // Rectangle Card
            if #available(iOS 14, *) {
                
                if #available(iOS 15, *) {
                    Image("custom.drink.fill-3.0")
                        .resizable()
                        .scaledToFit()
                        .frame(width: symbolSize, height: symbolSize)
                        .foregroundColor(model.grayscaleEnabled ? .primary : color)
                } else {
                    Image("custom.drink.fill-2.0")
                        .resizable()
                        .scaledToFit()
                        .frame(width: symbolSize, height: symbolSize)
                        .foregroundColor(model.grayscaleEnabled ? .primary : color)
                }
                
            } else {
                RectangleCard(color: model.grayscaleEnabled ? .primary : color)
                    .frame(width: symbolSize, height: symbolSize)
            }
            
            HStack {
                if !sizeCategory.isAccessibilityCategory {
                    VStack(alignment: .leading) {
                        // Drink Name
                        Text(drinkType)
                            .font(.title)
                            .bold()
                        
                        // Consumed Amount & Percent
                        let amount = selectedTimePeriod == Constants.selectDay ? model.getDrinkTypeAmount(type: drinkType, date: selectedDay) : model.getDrinkTypeAmount(type: drinkType, week: selectedWeek)
                        
                        let percent = selectedTimePeriod == Constants.selectDay ? model.getDrinkTypePercent(type: drinkType, date: selectedDay) : model.getDrinkTypePercent(type: drinkType, week: selectedWeek)
                        
                        
                        HStack {
                            Text("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getUnits())")
                                .font(.title2)
                            
                            Text("\(percent*100, specifier: "%.2f")%")
                                .font(.title2)
                        }
                    }
                } else {
                    VStack(alignment: .leading) {
                        // Drink Name
                        Text(drinkType)
                            .font(.title)
                            .bold()
                        
                        // Consumed Amount & Percent
                        let amount = selectedTimePeriod == Constants.selectDay ? model.getDrinkTypeAmount(type: drinkType, date: selectedDay) : model.getDrinkTypeAmount(type: drinkType, week: selectedWeek)
                        
                        let percent = selectedTimePeriod == Constants.selectDay ? model.getDrinkTypePercent(type: drinkType, date: selectedDay) : model.getDrinkTypePercent(type: drinkType, week: selectedWeek)
                        
                       Text("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getUnits())")
                            .font(sizeCategory == .accessibilityExtraExtraLarge || sizeCategory == .accessibilityExtraExtraExtraLarge ? .caption2 : .title2)

                        Text("\(percent*100, specifier: "%.2f")%")
                            .font(sizeCategory == .accessibilityExtraExtraLarge || sizeCategory == .accessibilityExtraExtraExtraLarge ? .caption2 : .title2)

                    }
                }
                
                Spacer()
            }
        }
    }
}

struct IntakeSingleDrinkBreakup_Previews: PreviewProvider {
    static var previews: some View {
        IntakeSingleDrinkBreakup(color: Color(.systemTeal), drinkType: Constants.waterKey, selectedTimePeriod: Constants.selectDay, selectedDay: Date(), selectedWeek: DrinkModel().getWeekRange(date: Date()))
            .environmentObject(DrinkModel())
    }
}
