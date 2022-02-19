//
//  IntakeCircularProgressBar.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct IntakeCircularProgressBar: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.dynamicTypeSize) var dynamicType
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    @AccessibilityFocusState private var isIntakeInfoFocused: Bool
    
    var selectedTimePeriod: Constants.TimePeriod
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
                    let color = totalPercent >= 1.0 ? self.getHighlightColor(type: drinkTypes.last!) : self.getHighlightColor(type: type)
                    
                    IntakeCircularProgressBarHighlight(progress: self.getProgressPercent(type: type), color: color, width: 30)
                }
            }

            // If a day display the daily percent
            if selectedTimePeriod == .daily {
                
                VStack {
                    // Show a flag symbol when the goal is reached and Differentiate Without Color is enabled
                    if (self.differentiateWithoutColor || model.grayscaleEnabled) && totalPercent >= 1.0 {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.primary)
                            .font(self.getFontStyleAmount())
                            .padding(.bottom, 0.5)
                            .accessibilityHidden(true)
                    }
                    
                    // Get percentage of liquid drank for selectedDay
                    let percent = model.getTotalPercentByDay(date: selectedDay)
                    
                    Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                        .font(self.getFontStylePercent())
                        .bold()
                        .padding(.bottom, 5)
                        .accessibilityLabel("\(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))\(totalPercent >= 1.0 ? ", Daily Goal Reached" : "")")
                        .accessibilitySortPriority(0)
                    
                    // Get the total amount of liquid drank for selectedDay
                    let total = model.getTotalAmountByDay(date: selectedDay)
                    
                    Text("\(total, specifier: model.getSpecifier(amount: total)) \(model.getUnits())")
                        .font(getFontStyleAmount())
                        .foregroundColor(Color(.systemGray))
                        .accessibilityLabel("\(total, specifier: model.getSpecifier(amount: total)) \(model.getAccessibilityUnitLabel())")
                        .accessibilitySortPriority(1)
                }
                .accessibilityElement(children: .combine)
                .accessibilityFocused($isIntakeInfoFocused)
                
            // If a week display the weekly percent
            } else if selectedTimePeriod == .weekly {
                
                VStack {
                    // Show a flag symbol when the goal is reached and Differentiate Without Color is enabled
                    if (self.differentiateWithoutColor || model.grayscaleEnabled) && totalPercent >= 1.0 {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.primary)
                            .font(self.getFontStyleAmount())
                            .padding(.bottom, 0.5)
                            .accessibilityHidden(true)
                    }
                    
                    // Get percentage of liquid drinked over selectedWeek
                    let percent = model.getTotalPercentByWeek(week: selectedWeek)
                    
                    Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                        .font(self.getFontStylePercent())
                        .bold()
                        .padding(.bottom, 5)
                        .accessibilityLabel("\(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))\(totalPercent >= 1.0 ? ", Weekly Goal Reached" : "")")
                        .accessibilitySortPriority(0)

                    
                    // Get the amount of liquid drank over selectedWeek
                    let total = model.getTotalAmountByWeek(week: selectedWeek)
                    
                    Text("\(total, specifier: model.getSpecifier(amount: total)) \(model.getUnits())")
                        .font(self.getFontStyleAmount())
                        .foregroundColor(Color(.systemGray))
                        .accessibilityLabel("\(total, specifier: model.getSpecifier(amount: total)) \(model.getAccessibilityUnitLabel()) consumed")
                        .accessibilitySortPriority(1)
                }
                .accessibilityElement(children: .combine)
                .accessibilityFocused($isIntakeInfoFocused)
            }
        }
        .padding(.horizontal)
        .multilineTextAlignment(.center)
        .onChange(of: model.drinkData.drinks.count) { _ in
            isIntakeInfoFocused = true
        }
    }
    
    private func getProgressPercent(type: String) -> Double {
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
        if selectedTimePeriod == .daily {
            // Loop through type index...
            for index in 0...typeIndex {
                // To get trim value for type
                progress += model.getTypePercentByDay(type: drinkTypes[index], date: selectedDay)
            }
        // If selectedTimePeriod is Week...
        } else {
            // Loop through type index...
            for index in 0...typeIndex {
                // To get trim value for type
                progress += model.getTypePercentByWeek(type: drinkTypes[index], week: selectedWeek)
            }
        }
        
        return progress
        
    }
    
    private func getFontStylePercent() -> SwiftUI.Font {
        if !dynamicType.isAccessibilitySize {
            return .largeTitle
        } else if dynamicType == .accessibility1 {
            return .title
        } else if dynamicType == .accessibility2 {
            return .title2
        } else if dynamicType == .accessibility3 {
            return .callout
        } else if dynamicType == .accessibility4 {
            return .footnote
        } else {
            return .caption2
        }
    }
    
    private func getFontStyleAmount() -> SwiftUI.Font {
        if !dynamicType.isAccessibilitySize || dynamicType == .accessibility1 || dynamicType == .accessibility2 {
            return .body
        } else if dynamicType == .accessibility3 {
            return .caption
        } else {
            return .caption2
        }
    }
    
    private func getHighlightColor(type: String) -> Color {
        let totalPercent = self.getProgressPercent(type: type)
        
        if totalPercent >= 1.0 {
            return Color("GoalGreen")
        } else {
            if model.grayscaleEnabled {
                return .primary
            } else {
                return model.getDrinkTypeColor(type: type)
            }
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
