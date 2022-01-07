//
//  DayLogView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/21/21.
//

import SwiftUI

struct DayLogView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    @EnvironmentObject var model: DrinkModel
        
    var drink: Drink
    
    var body: some View {
        
        // If Accessibility Dynamic Type Size...
        if !model.grayscaleEnabled && !differentiateWithoutColor {
            if !sizeCategory.isAccessibilityCategory {
                HStack {
                    // Colored Drop
                    if #available(iOS 14, *) {
                        // if iOS 15, use palette symbol
                        if #available(iOS 15, *) {
                            Image("custom.drink.fill-3.0")
                                .font(.title)
                                .foregroundColor(model.getDrinkTypeColor(type: drink.type))
                                .padding(.trailing)
                            // if iOS 14, use monochrome symbol
                        } else {
                            Image("custom.drink.fill-2.0")
                                .font(.title)
                                .foregroundColor(model.getDrinkTypeColor(type: drink.type))
                                .padding(.trailing)
                        }
                        // if iOS 13 or older, use drop.fill symbol
                    } else {
                        Image(systemName: "drop.fill")
                            .font(.title)
                            .foregroundColor(model.getDrinkTypeColor(type: drink.type))
                    }
                    
                    Spacer()
                    
                    // Amount consumed
                    Text("\(drink.amount, specifier: model.getSpecifier(amount: drink.amount)) \(model.getUnits())")
                        .font(.title3)
                    
                    Spacer()
                    
                    let formatter = formatter()
                    
                    // Time drink was logged
                    Text(formatter.string(from: drink.date))
                        .padding(.leading, 10)
                        .font(.title3)
                }
                // If not...
            } else {
                VStack(alignment: .leading) {
                    // Colored Drop
                    if #available(iOS 14, *) {
                        // if iOS 15, use palette symbol
                        if #available(iOS 15, *) {
                            Image("custom.drink.fill-3.0")
                                .font(.title)
                                .foregroundColor(model.getDrinkTypeColor(type: drink.type))
                                .padding(.trailing)
                            // if iOS 14, use monochrome symbol
                        } else {
                            Image("custom.drink.fill-2.0")
                                .font(.title)
                                .foregroundColor(model.getDrinkTypeColor(type: drink.type))
                                .padding(.trailing)
                        }
                        // if iOS 13 or older, use drop.fill symbol
                    } else {
                        Image(systemName: "drop.fill")
                            .font(.title)
                            .foregroundColor(model.getDrinkTypeColor(type: drink.type))
                    }
                    
                    // Amount consumed
                    Text("\(drink.amount, specifier: model.getSpecifier(amount: drink.amount)) \(model.getUnits())")
                        .font(.title3)
                    
                    let formatter = formatter()
                    
                    // Time drink was logged
                    Text(formatter.string(from: drink.date))
                        .font(.title3)
                }
            }
        } else {
            VStack(alignment: .leading) {
                Text(drink.type)
                    .font(.title2)
                    .bold()
                
                if !sizeCategory.isAccessibilityCategory {
                    HStack {
                        Text("\(drink.amount, specifier: model.getSpecifier(amount: drink.amount)) \(model.getUnits())")
                            .font(.title3)
                        
                        let formatter = formatter()
                        
                        // Time drink was logged
                        Text(formatter.string(from: drink.date))
                            .font(.title3)
                    }
                } else {
                    Text("\(drink.amount, specifier: model.getSpecifier(amount: drink.amount)) \(model.getUnits())")
                        .font(.title3)
                    
                    let formatter = formatter()
                    
                    // Time drink was logged
                    Text(formatter.string(from: drink.date))
                        .font(.title3)
                }
            }
        }
    }
    
    func formatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
}

struct SingleLogView_Previews: PreviewProvider {
    static var previews: some View {
        DayLogView(drink: Drink(type: Constants.waterKey, amount: 100.0, date: Date()))
            .environmentObject(DrinkModel())
    }
}
