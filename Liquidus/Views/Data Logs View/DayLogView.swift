//
//  DayLogView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/21/21.
//

import SwiftUI

struct DayLogView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicType
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    @EnvironmentObject var model: DrinkModel
        
    var drink: Drink
    
    var body: some View {
        
        // If Accessibility Dynamic Type Size...
        if !model.grayscaleEnabled && !differentiateWithoutColor {
            if !dynamicType.isAccessibilitySize {
                HStack {
                    Image("custom.drink.fill")
                        .font(.title)
                        .foregroundColor(model.getDrinkTypeColor(type: drink.type))
                        .padding(.trailing)
                        .accessibilityLabel(drink.type)
                        .accessibilityRemoveTraits(.isImage)
                    
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
                .accessibilityElement(children: .combine)
                // If not...
            } else {
                VStack(alignment: .leading) {
                    Image("custom.drink.fill")
                        .font(.title)
                        .foregroundColor(model.getDrinkTypeColor(type: drink.type))
                        .padding(.trailing)
                        .accessibilityLabel(drink.type)
                        .accessibilityRemoveTraits(.isImage)
                        .accessibilityAddTraits(.isStaticText)
                    
                    // Amount consumed
                    Text("\(drink.amount, specifier: model.getSpecifier(amount: drink.amount)) \(model.getUnits())")
                        .font(.title3)
                    
                    let formatter = formatter()
                    
                    // Time drink was logged
                    Text(formatter.string(from: drink.date))
                        .font(.title3)
                }
                .accessibilityElement(children: .combine)
            }
        } else {
            VStack(alignment: .leading) {
                Text(drink.type)
                    .font(.title2)
                    .bold()
                
                if !dynamicType.isAccessibilitySize {
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
            .accessibilityElement(children: .combine)
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
