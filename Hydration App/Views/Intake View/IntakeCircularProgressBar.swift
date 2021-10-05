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
    
    var body: some View {
        
        ZStack {
            
            // Create circle background
            Circle()
                .stroke(lineWidth: 30)
                .foregroundColor(Color(.systemGray6))
            
            let totalPercent = self.getProgressPercent(type: model.drinkData.drinkTypes.last!, timePeriod: selectedTimePeriod)
            
            // Get the outline fill for each type
            ForEach(model.drinkData.drinkTypes.reversed(), id: \.self) { type in
                
                let color = totalPercent >= 1.0 ? Color("GoalGreen") : model.drinkData.colors[type]!.getColor()
                
                IntakeCircularProgressBarHighlight(progress: self.getProgressPercent(type: type, timePeriod: selectedTimePeriod), color: color)
            }

            // If a day display the daily percent
            if selectedTimePeriod == Constants.selectDay {
                
                VStack {
                    let percent = model.getTotalPercent(date: model.drinkData.selectedDay)
                    
                    Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 5)
                    
                    let total = model.getTotalAmount(date: model.drinkData.selectedDay)
                    let goal = model.drinkData.dailyGoal
                    
                    Text("\(total, specifier: model.getSpecifier(amount: total)) / \(goal, specifier: model.getSpecifier(amount: goal)) \(model.getUnits())")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                }
                
            // If a week display the weekly percent
            } else {
                
                VStack {
                    let percent = model.getTotalPercent(week: model.drinkData.selectedWeek)
                    
                    Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", min(percent, 1.0)*100.0))
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 5)
                    
                    let total = model.getTotalAmount(week: model.drinkData.selectedWeek)
                    let goal = model.drinkData.dailyGoal*7
                    
                    Text("\(total, specifier: model.getSpecifier(amount: total)) / \(goal, specifier: model.getSpecifier(amount: goal)) \(model.getUnits())")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                }
            }
            
        }
        .padding(.horizontal)
        
    }
    
    func getProgressPercent(type: String, timePeriod: String) -> Double {
        let typeIndex = model.drinkData.drinkTypes.firstIndex(of: type)!
        
        var progress = 0.0
        
        if timePeriod == Constants.selectDay {
            for index in 0...typeIndex {
                progress += model.getDrinkTypePercent(type: model.drinkData.drinkTypes[index], date: model.drinkData.selectedDay)
            }
        } else {
            for index in 0...typeIndex {
                progress += model.getDrinkTypePercent(type: model.drinkData.drinkTypes[index], week: model.drinkData.selectedWeek)
            }
        }
        
        return progress
        
    }
}
