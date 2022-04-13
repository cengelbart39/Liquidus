//
//  IntakeCircularProgressInfo.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 3/24/22.
//

import SwiftUI

struct IntakeCircularProgressInfo: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.dynamicTypeSize) var dynamicType
    
    var timePeriod: Constants.TimePeriod
    var day: Date
    var week: [Date]
    var totalPercent: Double
    
    var body: some View {
        
        if timePeriod == .daily {
            
            VStack {
                // Show a flag symbol when the goal is reached and Differentiate Without Color is enabled
                if (self.differentiateWithoutColor || model.grayscaleEnabled) && totalPercent >= 1.0 {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.primary)
                        .font(self.getFontStyleAmount())
                        .padding(.bottom, 0.5)
                        .accessibilityHidden(true)
                }
                
                // Get percentage of liquid drank for day
                let percent = model.getTotalPercentByDay(date: day)
                
                Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                    .font(self.getFontStylePercent())
                    .bold()
                    .padding(.bottom, 5)
                    .accessibilityLabel("\(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))\(totalPercent >= 1.0 ? ", Daily Goal Reached" : "")")
                    .accessibilitySortPriority(0)
                
                // Get the total amount of liquid drank for day
                let total = model.getTotalAmountByDay(date: day)
                
                Text("\(total, specifier: model.getSpecifier(amount: total)) \(model.getUnits())")
                    .font(getFontStyleAmount())
                    .foregroundColor(Color(.systemGray))
                    .accessibilityLabel("\(total, specifier: model.getSpecifier(amount: total)) \(model.getAccessibilityUnitLabel())")
                    .accessibilitySortPriority(1)
            }
            .accessibilityElement(children: .combine)
            
        // If a week display the weekly percent
        } else if timePeriod == .weekly {
            
            VStack {
                // Show a flag symbol when the goal is reached and Differentiate Without Color is enabled
                if (self.differentiateWithoutColor || model.grayscaleEnabled) && totalPercent >= 1.0 {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.primary)
                        .font(self.getFontStyleAmount())
                        .padding(.bottom, 0.5)
                        .accessibilityHidden(true)
                }
                
                // Get percentage of liquid drinked over week
                let percent = model.getTotalPercentByWeek(week: week)
                
                Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                    .font(self.getFontStylePercent())
                    .bold()
                    .padding(.bottom, 5)
                    .accessibilityLabel("\(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))\(totalPercent >= 1.0 ? ", Weekly Goal Reached" : "")")
                    .accessibilitySortPriority(0)

                
                // Get the amount of liquid drank over week
                let total = model.getTotalAmountByWeek(week: week)
                
                Text("\(total, specifier: model.getSpecifier(amount: total)) \(model.getUnits())")
                    .font(self.getFontStyleAmount())
                    .foregroundColor(Color(.systemGray))
                    .accessibilityLabel("\(total, specifier: model.getSpecifier(amount: total)) \(model.getAccessibilityUnitLabel()) consumed")
                    .accessibilitySortPriority(1)
            }
            .accessibilityElement(children: .combine)
        }
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
}
