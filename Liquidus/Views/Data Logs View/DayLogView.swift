//
//  DayLogView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/21/21.
//

import SwiftUI

struct DayLogView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var model: DrinkModel
    
    var drink: Drink
    
    var body: some View {
        
        ZStack {
            
            RectangleCard(color: colorScheme == .light ? .white : Color(.systemGray6))
                .frame(height: 70)
                .shadow(radius: 5)
            
            HStack {
                
                Spacer()
                
                // Colored Drop
                Image(systemName: "drop.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                    .foregroundColor(model.drinkData.colors[drink.type]!.getColor())
                    .padding(.trailing)
                
                // Amount consumed
                Text("\(drink.amount, specifier: model.getSpecifier(amount: drink.amount)) \(model.getUnits())")
                    .padding(.trailing, 10)
                
                let formatter = formatter()
                    
                // Time drink was logged
                Text(formatter.string(from: drink.date))
                
                Spacer()
            }
            
        }
        
    }
    
    func formatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }
}

struct SingleLogView_Previews: PreviewProvider {
    static var previews: some View {
        DayLogView(drink: Drink(type: Constants.waterKey, amount: 100.0, date: Date()))
            .environmentObject(DrinkModel())
    }
}
