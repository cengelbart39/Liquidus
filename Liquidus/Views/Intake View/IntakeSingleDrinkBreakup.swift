//
//  IntakeSingleDrinkBreakup.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/10/21.
//

import SwiftUI

struct IntakeSingleDrinkBreakup: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.dynamicTypeSize) var dynamicType
    
    var color: Color
    var drinkType: DrinkType
    var day: Day
    @Binding var trigger: Bool
        
    @ScaledMetric(relativeTo: .body) var symbolSize = 35
    
    var body: some View {
        
        HStack {
            
            // Rectangle Card
            Image("custom.drink.fill")
                .resizable()
                .scaledToFit()
                .frame(width: symbolSize, height: symbolSize)
                .foregroundColor(model.grayscaleEnabled ? .primary : color)
                .accessibilityHidden(true)
            
            HStack {
                if !dynamicType.isAccessibilitySize {
                    VStack(alignment: .leading) {
                        // Drink Name
                        Text(drinkType.name)
                            .font(.title)
                            .bold()
                        
                        // Consumed Amount & Percent
                        let amount = model.getTypeAmountByDay(type: drinkType, day: day)
                        
                        let percent = model.getTypePercentByDay(type: drinkType, day: day)
                        
                        HStack {
                            Text("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getUnits())")
                                .font(.title2)
                                .accessibilityLabel("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getAccessibilityUnitLabel())")
                            
                            Text("\(percent*100, specifier: "%.2f")%")
                                .font(.title2)
                                .accessibilityLabel("\(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))")
                        }
                    }
                } else {
                    VStack(alignment: .leading) {
                        // Drink Name
                        Text(drinkType.name)
                            .font(.title)
                            .bold()
                            .accessibilityAddTraits(.isHeader)
                        
                        // Consumed Amount & Percent
                        let amount = model.getTypeAmountByDay(type: drinkType, day: day)
                        
                        let percent = model.getTypePercentByDay(type: drinkType, day: day)
                        
                       Text("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getUnits())")
                            .font(dynamicType == .accessibility4 || dynamicType == .accessibility5 ? .caption2 : .title2)
                            .accessibilityLabel("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getAccessibilityUnitLabel()) of \(drinkType.name)")

                        Text("\(percent*100, specifier: "%.2f")%")
                            .font(dynamicType == .accessibility4 || dynamicType == .accessibility5 ? .caption2 : .title2)
                            .accessibilityLabel("\(percent*100, specifier: "%.2f")% \(drinkType.name)")
                    }
                }
                
                Spacer()
            }
        }
        .accessibilityElement(children: .combine)
        .onChange(of: trigger) { newValue in
            trigger = newValue
        }
    }
}
