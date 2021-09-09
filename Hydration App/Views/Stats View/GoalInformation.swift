//
//  GoalInformation.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct GoalInformation: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var model: DrinkModel
    
    var headline: String
    var amount: Double
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            RectangleCard(color: colorScheme == .light ? Color.white : Color(.systemGray6))
                .frame(height: 60)
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: -5) {
                Text(headline)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("\(amount, specifier: "%.0f") \(model.drinkData.units)")
                    .font(.title)
            }
            .padding(.leading, 10)
        }
        
    }
}
