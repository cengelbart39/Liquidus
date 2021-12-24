//
//  IntakeCircularProgressBar.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct IntakeCircularProgressBar: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var selectedTimePeriod: String
    var selectedDay: Date
    var selectedWeek: [Date]
    
    var body: some View {
        
        ZStack {
            
            // Create circle background
            Circle()
                .stroke(lineWidth: 30)
                .foregroundColor(Color(.systemGray6))
            
            // Get all drink types
            let drinkTypes = model.drinkData.defaultDrinkTypes + model.drinkData.customDrinkTypes
            
            // Get total percentage of liquid consumed
            let totalPercent = self.getProgressPercent(type: drinkTypes.last!)
            
            // Get the outline fill for each type
            ForEach(drinkTypes.reversed(), id: \.self) { type in
                
                // If the drink type is enabled...
                if model.drinkData.enabled[type]! {
                    // Get color for highlight
                    // Use drink type color if goal isn't reached
                    // Use "GoalGreen" if goal is reached
                    let color = totalPercent >= 1.0 ? Color("GoalGreen") : model.drinkData.colors[type]!.getColor()
                    
                    IntakeCircularProgressBarHighlight(progress: self.getProgressPercent(type: type), color: color)
                }
            }

            // If a day display the daily percent
            if selectedTimePeriod == Constants.selectDay {
                
                VStack {
                    // Get percentage of liquid drank for selectedDay
                    let percent = model.getTotalPercent(date: selectedDay)
                    
                    Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 5)
                    
                    // Get the total amount of liquid drank for selectedDay
                    let total = model.getTotalAmount(date: selectedDay)
                    
                    // Get daily goal
                    let goal = model.drinkData.dailyGoal
                    
                    Text("\(total, specifier: model.getSpecifier(amount: total)) / \(goal, specifier: model.getSpecifier(amount: goal)) \(model.getUnits())")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                }
                
            // If a week display the weekly percent
            } else if selectedTimePeriod == Constants.selectWeek {
                
                VStack {
                    // Get percentage of liquid drinked over selectedWeek
                    let percent = model.getTotalPercent(week: selectedWeek)
                    
                    Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 5)
                    
                    // Get the amount of liquid drank over selectedWeek
                    let total = model.getTotalAmount(week: selectedWeek)
                    
                    // Get weekly goal
                    let goal = model.drinkData.dailyGoal*7
                    
                    Text("\(total, specifier: model.getSpecifier(amount: total)) / \(goal, specifier: model.getSpecifier(amount: goal)) \(model.getUnits())")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                }
            }
            
        }
        .padding(.horizontal)
        
    }
    
    func getProgressPercent(type: String) -> Double {
        // Create an empty string array
        var drinkTypes = [String]()
        
        // Loop through default drink types
        for type in model.drinkData.defaultDrinkTypes {
            
            // if drink type is enabled...
            if model.drinkData.enabled[type]! {
                // add to drinkTypes
                drinkTypes += [type]
            }
        }
        
        // Add custom drink types to drinkTypes
        drinkTypes += model.drinkData.customDrinkTypes
        
        // Get the index of type in drinkTypes
        let typeIndex = drinkTypes.firstIndex(of: type)!
        
        var progress = 0.0
        
        // If selectedTimePeriod is Day...
        if selectedTimePeriod == Constants.selectDay {
            // Loop through type index...
            for index in 0...typeIndex {
                // To get trim value for type
                progress += model.getDrinkTypePercent(type: drinkTypes[index], date: selectedDay)
            }
        // If selectedTimePeriod is Week...
        } else {
            // Loop through type index...
            for index in 0...typeIndex {
                // To get trim value for type
                progress += model.getDrinkTypePercent(type: drinkTypes[index], week: selectedWeek)
            }
        }
        
        return progress
        
    }
}
