//
//  IntakeCircularProgressBar.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct IntakeCircularProgressBar: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.sizeCategory) var sizeCategory
        
    var selectedTimePeriod: String
    var selectedDay: Date
    var selectedWeek: [Date]
    
    var body: some View {
        
        ZStack {
            
            // Create circle background
            Circle()
                .stroke(lineWidth: 30)
                .foregroundColor(Color(.systemGray6))
                .scaledToFit()
            
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
                    let color = totalPercent >= 1.0 ? Color("GoalGreen") : model.getDrinkTypeColor(type: type)
                    
                    IntakeCircularProgressBarHighlight(progress: self.getProgressPercent(type: type), color: color)
                }
            }

            // If a day display the daily percent
            if selectedTimePeriod == Constants.selectDay {
                
                VStack {
                    // Get percentage of liquid drank for selectedDay
                    let percent = model.getTotalPercent(date: selectedDay)
                    
                    Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                        .font(getFontStylePercent())
                        .bold()
                        .padding(.bottom, 5)
                    
                    // Get the total amount of liquid drank for selectedDay
                    let total = model.getTotalAmount(date: selectedDay)
                    
                    Text("\(total, specifier: model.getSpecifier(amount: total)) \(model.getUnits())")
                        .font(getFontStyleAmount())
                        .foregroundColor(Color(.systemGray))
                }
                
            // If a week display the weekly percent
            } else if selectedTimePeriod == Constants.selectWeek {
                
                VStack {
                    // Get percentage of liquid drinked over selectedWeek
                    let percent = model.getTotalPercent(week: selectedWeek)
                    
                    Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                        .font(getFontStylePercent())
                        .bold()
                        .padding(.bottom, 5)
                    
                    // Get the amount of liquid drank over selectedWeek
                    let total = model.getTotalAmount(week: selectedWeek)
                    
                    Text("\(total, specifier: model.getSpecifier(amount: total)) \(model.getUnits())")
                        .font(getFontStyleAmount())
                        .foregroundColor(Color(.systemGray))
                }
            }
            
        }
        .padding(.horizontal)
        .multilineTextAlignment(.center)
        
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
    
    func getFontStylePercent() -> SwiftUI.Font {
        if !sizeCategory.isAccessibilityCategory {
            return .largeTitle
        } else if sizeCategory == .accessibilityMedium {
            return .title
        } else if sizeCategory == .accessibilityLarge {
            return .title2
        } else if sizeCategory == .accessibilityExtraLarge {
            return .callout
        } else if sizeCategory == .accessibilityExtraExtraLarge {
            return .footnote
        } else {
            return .caption2
        }
    }
    
    func getFontStyleAmount() -> SwiftUI.Font {
        if !sizeCategory.isAccessibilityCategory || sizeCategory == .accessibilityMedium || sizeCategory == .accessibilityLarge {
            return .body
        } else if sizeCategory == .accessibilityExtraLarge {
            return .caption
        } else {
            return .caption2
        }
    }
}

struct IntakeCircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        IntakeCircularProgressBar(selectedTimePeriod: Constants.selectDay, selectedDay: Date(), selectedWeek: DrinkModel().getWeekRange(date: Date()))
            .environment(\.sizeCategory, .large)
            .environmentObject(DrinkModel())
    }
}
