//
//  CircularProgressBar.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct CircularProgressBar: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var progressWater: Double
    var progressCoffee: Double
    var progressSoda: Double
    var progressJuice: Double
    var selectedTimePeriod: String
    
    var body: some View {
        
        ZStack {
            
            // Create circle background
            Circle()
                .stroke(lineWidth: 30)
                .foregroundColor(Color(.systemGray6))
            
            // Get the outline fill for each type
            CircularProgressBarHighlight(progress: progressJuice+progressSoda+progressCoffee+progressWater, color: Constants.colors[Constants.juiceKey]!)
            
            CircularProgressBarHighlight(progress: progressSoda+progressCoffee+progressWater, color: Constants.colors[Constants.sodaKey]!)
            
            CircularProgressBarHighlight(progress: progressCoffee+progressWater, color: Constants.colors[Constants.coffeeKey]!)
            
            CircularProgressBarHighlight(progress: progressWater, color: Constants.colors[Constants.waterKey]!)
            
            // If a day display the daily percent
            if selectedTimePeriod == Constants.selectDay {
                Text(String(format: "%.2f%%", min(model.getTotalPercent(date: model.drinkData.selectedDay), 1.0)*100.0))
                    .font(.largeTitle)
                    .bold()
            // If a week display the weekly percent
            } else {
                Text(String(format: "%.2f%%", min(model.getTotalPercent(week: model.drinkData.selectedWeek), 1.0)*100.0))
                    .font(.largeTitle)
                    .bold()
            }
            
        }
        .padding(.horizontal)
        
    }
}
