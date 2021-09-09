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
    var drinkAmount: Double
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            RectangleCard(color: color)
            
            VStack(alignment: .leading) {
                
                Text(String(format: "%.2f%%", min(model.getDrinkTypePercent(type: drinkName, date: Date()), 1.0)*100.0))
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 8)
                
                Text(drinkName)
                    .font(.subheadline)
                
                Text("\(drinkAmount, specifier: "%.0f") \(model.drinkData.units)")
                    .font(.headline)
                
            }
            .foregroundColor(.white)
            .padding(.leading, 8)
        }
        
    }
}
