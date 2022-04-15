//
//  IntakeCircularProgressBar.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct IntakeCircularProgressBar: View {
    
    @EnvironmentObject var model: DrinkModel
    
    
    @AccessibilityFocusState private var isIntakeInfoFocused: Bool
    
    var selectedTimePeriod: Constants.TimePeriod
    var selectedDay: Date
    var selectedWeek: [Date]
    
    var body: some View {
        
        ZStack {
            
            // Get total percentage of liquid consumed
            let totalPercent = model.getProgressPercent(type: model.drinkData.drinkTypes.last!, dates: selectedTimePeriod == .daily ? selectedDay : selectedWeek)
            
            IntakeCircularProgressDisplay(timePeriod: selectedTimePeriod, day: selectedDay, week: selectedWeek, totalPercent: totalPercent, width: 30)

            // If a day display the daily percent
            IntakeCircularProgressInfo(timePeriod: selectedTimePeriod, day: selectedDay, week: selectedWeek, totalPercent: totalPercent)
                .accessibilityFocused($isIntakeInfoFocused)
        }
        .padding(.horizontal)
        .multilineTextAlignment(.center)
        .onChange(of: model.drinkData.drinks.count) { _ in
            isIntakeInfoFocused = true
        }
    }
}

struct IntakeCircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        IntakeCircularProgressBar(selectedTimePeriod: .daily, selectedDay: Date(), selectedWeek: DrinkModel().getWeekRange(date: Date()))
            .environment(\.sizeCategory, .large)
            .environmentObject(DrinkModel())
    }
}
