//
//  IntakeCircularProgressDisplay.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 3/23/22.
//
//  Based off of:
//  https://www.simpleswiftguide.com/how-to-build-a-circular-progress-bar-in-swiftui/
//

import SwiftUI

struct IntakeCircularProgressDisplay: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var timePeriod: Constants.TimePeriod
    var day: Date
    var week: [Date]
    var drinkTypes: [String]
    var totalPercent: Double
    var width: CGFloat
    
    var body: some View {
        
        ZStack {
            // Create circle background
            Circle()
                .stroke(lineWidth: width)
                .foregroundColor(Color(.systemGray6))
                .scaledToFit()
            
            // Get the outline fill for each type
            ForEach(drinkTypes.reversed(), id: \.self) { type in
                
                // If the drink type is enabled...
                if model.drinkData.enabled[type]! {
                    // Get color for highlight
                    // Use drink type color if goal isn't reached
                    // Use "GoalGreen" if goal is reached
                    let color = totalPercent >= 1.0 ? model.getHighlightColor(type: drinkTypes.last!, dates: self.getDates()) : model.getHighlightColor(type: type, dates: self.getDates())

                    IntakeCircularProgressBarHighlight(progress: model.getProgressPercent(type: type, dates: timePeriod == .daily ? day : week), color: color, width: width)
                }
            }
        }
        
    }
    
    private func getDates() -> Any {
        if timePeriod == .daily {
            return day
            
        } else {
            return week
        }
    }
}
