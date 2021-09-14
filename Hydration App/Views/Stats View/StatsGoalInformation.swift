//
//  StatsGoalInformation.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct StatsGoalInformation: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var model: DrinkModel
    
    var headline: String
    var amount: Double
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            // Create card
            RectangleCard(color: colorScheme == .light ? Color.white : Color(.systemGray6))
                .frame(height: 60)
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: -5) {
                // title
                Text(headline)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // amount
                Text("\(amount, specifier: model.getSpecifier(amount: amount)) \(model.getUnits())")
                    .font(.title)
            }
            .padding(.leading, 10)
        }
        
    }
}
