//
//  MediumWidgetView.swift
//  IntakeWidgetExtension
//
//  Created by Christopher Engelbart on 1/15/22.
//

import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
    @EnvironmentObject var model: DrinkModel
        
    @Environment(\.dynamicTypeSize) var dynamicType
    
    var entry: SimpleEntry
    
    @ScaledMetric(relativeTo: .footnote) var symbolSize1 = 15
    @ScaledMetric(relativeTo: .footnote) var symbolSize2 = 10
    @ScaledMetric(relativeTo: .footnote) var symbolSize3 = 7
    
    var body: some View {
        
        GeometryReader { geo in
            HStack {
                
                Spacer()
                
                ZStack {
                    // Create circle background
                    Circle()
                        .stroke(lineWidth: 20)
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
                            
                            IntakeCircularProgressBarHighlight(progress: self.getProgressPercent(type: type), color: color, width: 20)
                        }
                    }
                }
                .padding([.leading, .vertical])
                .padding(.trailing, 10)
                .widgetURL(entry.timePeriod == Constants.selectDay ? Constants.intakeDailyURL : Constants.intakeWeeklyURL)
                .frame(height: geo.size.height/1.1)
                
                Divider()
                    .padding(.leading, 10)
                    .padding(.vertical)
                
                Spacer()
                
                let drinkTypes = model.drinkData.defaultDrinkTypes + model.drinkData.customDrinkTypes
                
                let nonZeroTypes = self.nonZeroTypes(types: drinkTypes)
                
                VStack(alignment: .leading, spacing: 10) {
                    if !nonZeroTypes.isEmpty {
                        
                        let percent = entry.timePeriod == Constants.selectDay ? model.getTotalPercent(date: entry.date) : model.getTotalPercent(week: model.getDaysInWeek(date: entry.date))
                        
                        Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                            .font(dynamicType.isAccessibilitySize ? .body : .title3)
                            .bold()
                        
                        if nonZeroTypes.count > 2 {
                            let viewableDrinkTypes = [nonZeroTypes[0], nonZeroTypes[1]]
                            
                            ForEach(viewableDrinkTypes, id: \.self) { type in
                                VStack(alignment: .leading) {
                                    
                                    HStack(spacing: 0) {
                                        Image("custom.drink.fill")
                                            .font(.system(size: getSymbolSize()))
                                            .accessibilityHidden(true)
                                        
                                        Text(type)
                                            .bold()
                                            .font(dynamicType.isAccessibilitySize ? .footnote : .subheadline)
                                    }
                                    .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                    .padding(.leading, -5)
                                    
                                    let typeAmount = entry.timePeriod == Constants.selectDay ? model.getDrinkTypeAmount(type: type, date: entry.date) : model.getDrinkTypeAmount(type: type, week: model.getDaysInWeek(date: entry.date))
                                    
                                    let typePercent = entry.timePeriod == Constants.selectDay ? model.getDrinkTypePercent(type: type, date: entry.date) : model.getDrinkTypePercent(type: type, week: model.getDaysInWeek(date: entry.date))
                                    
                                    HStack {
                                        Text("\(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getUnits())")
                                            .font(dynamicType.isAccessibilitySize ? .caption2 : .caption)
                                            .accessibilityLabel("\(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getAccessibilityUnitLabel())")
                                        
                                        Text("\(typePercent*100, specifier: "%.2f")%")
                                            .font(dynamicType.isAccessibilitySize ? .caption2 : .caption)
                                            .accessibilityLabel("\(typePercent*100, specifier: "%.2f")%")
                                    }
                                    
                                }
                                .accessibilityElement(children: .combine)
                                
                            }
                            .widgetURL(entry.timePeriod == Constants.selectDay ? Constants.intakeDailyURL : Constants.intakeWeeklyURL)
                        } else {
                            ForEach(nonZeroTypes, id: \.self) { type in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Image("custom.drink.fill")
                                            .font(.system(size: getSymbolSize()))
                                            .accessibilityHidden(true)
                                        
                                        Text(type)
                                            .bold()
                                            .font(dynamicType.isAccessibilitySize ? .footnote : .subheadline)
                                    }
                                    .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                    
                                    let typeAmount = entry.timePeriod == Constants.selectDay ? model.getDrinkTypeAmount(type: type, date: entry.date) : model.getDrinkTypeAmount(type: type, week: model.getDaysInWeek(date: entry.date))
                                    
                                    let typePercent = entry.timePeriod == Constants.selectDay ? model.getDrinkTypePercent(type: type, date: entry.date) : model.getDrinkTypePercent(type: type, week: model.getDaysInWeek(date: entry.date))
                                    
                                    HStack {
                                        Text("\(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getUnits())")
                                            .font(dynamicType.isAccessibilitySize ? .caption2 : .caption)
                                            .accessibilityLabel("\(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getAccessibilityUnitLabel())")

                                        Text("\(typePercent*100, specifier: "%.2f")%")
                                            .font(dynamicType.isAccessibilitySize ? .caption2 : .caption)
                                            .accessibilityLabel("\(typePercent*100, specifier: "%.2f")%")

                                    }
                                }
                                .accessibilityElement(children: .combine)
                            }
                            .widgetURL(entry.timePeriod == Constants.selectDay ? Constants.intakeDailyURL : Constants.intakeWeeklyURL)
                        }
                        
                    } else {
                        VStack {
                            
                            Spacer()
                            
                            Text("Log a drink in the app to reach your \(entry.timePeriod == Constants.selectDay ? "daily" : "weekly") goal.")
                                .font(dynamicType.isAccessibilitySize ? .subheadline : .body)
                            
                            Spacer()
                        }
                        .widgetURL(entry.timePeriod == Constants.selectDay ? Constants.logDrinkDailyURL : Constants.logDrinkWeeklyURL)
                    }
                }
                .frame(width: geo.size.width/2)
                
                Spacer()
            }
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
        
        // If entry.relevance is Day...
        if entry.timePeriod == Constants.selectDay {
            // Loop through type index...
            for index in 0...typeIndex {
                // To get trim value for type
                progress += model.getDrinkTypePercent(type: drinkTypes[index], date: entry.date)
            }
            // If entry.relevance is Week...
        } else {
            // Loop through type index...
            for index in 0...typeIndex {
                // To get trim value for type
                progress += model.getDrinkTypePercent(type: drinkTypes[index], week: model.getDaysInWeek(date: entry.date))
            }
        }
        
        return progress
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
    
    // Filters out drink types based on if the user has consumed any
    // Then sorts by the greatest amount
    private func nonZeroTypes(types: [String]) -> [String] {
        var nonZeroTypes = [String]()
        
        for type in types {
            if model.getDrinkTypeAmount(type: type, date: entry.date) > 0.0 {
                nonZeroTypes.append(type)
            }
        }
        
        if !nonZeroTypes.isEmpty {
            nonZeroTypes.sort { model.getDrinkTypeAmount(type: $0, date: entry.date) > model.getDrinkTypeAmount(type: $1, date: entry.date) }
        }
        
        return nonZeroTypes
    }
    
    private func getSymbolSize() -> Double {
        if !dynamicType.isAccessibilitySize {
            return symbolSize1
        } else if dynamicType > .xxxLarge && dynamicType < .accessibility3 {
            return symbolSize2
        } else {
            return symbolSize3
        }
    }
}
