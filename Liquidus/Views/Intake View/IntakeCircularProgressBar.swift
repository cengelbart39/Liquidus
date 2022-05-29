//
//  IntakeCircularProgressBar.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct IntakeCircularProgressBar: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @AccessibilityFocusState private var isIntakeInfoFocused: Bool
    
    var day: Day
    @Binding var trigger: Bool
    
    var body: some View {
        
        ZStack {
            
            // Get total percentage of liquid consumed
            let totalPercent = model.getProgressPercent(type: model.drinkData.drinkTypes.last!, date: day)
            
            IntakeCircularProgressDisplay(day: day, totalPercent: totalPercent, width: 30, trigger: $trigger)

            // If a day display the daily percent
            IntakeCircularProgressInfo(day: day, totalPercent: totalPercent, trigger: $trigger)
                .accessibilityFocused($isIntakeInfoFocused)
        }
        .padding(.horizontal)
        .multilineTextAlignment(.center)
        .onChange(of: model.drinkData.drinks.count) { _ in
            isIntakeInfoFocused = true
        }
        .onChange(of: trigger) { newValue in
            trigger = newValue
        }
    }
}
