//
//  LargeWidgetView.swift
//  IntakeWidgetExtension
//
//  Created by Christopher Engelbart on 1/15/22.
//

import SwiftUI
import WidgetKit

struct LargeWidgetView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.dynamicTypeSize) var dynamicType
    
    var entry: SimpleEntry
    
    @ScaledMetric(relativeTo: .subheadline) var symbolSize = 15
    @ScaledMetric(relativeTo: .subheadline) var symbolSize2 = 12
    @ScaledMetric(relativeTo: .subheadline) var symbolSize3 = 8
    @ScaledMetric(relativeTo: .subheadline) var symbolSize4 = 7

    @ScaledMetric(relativeTo: .caption2) var fontSize1 = 7
    @ScaledMetric(relativeTo: .caption2) var fontSize2 = 6
    @ScaledMetric(relativeTo: .caption2) var fontSize3 = 5
    @ScaledMetric(relativeTo: .caption2) var fontSize4 = 4
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    // MARK: - Circular Progress Bar
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
                    .padding(.trailing)
                    
                    Spacer()
                    
                    // MARK: - Total Info
                    VStack(alignment: .leading) {
                        let percent = entry.timePeriod == .daily ? model.getTotalPercent(date: entry.date) : model.getTotalPercent(week: model.getDaysInWeek(date: entry.date))
                        
                        Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                            .font(.title)
                            .bold()
                            .accessibilityLabel(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                        
                        let total = entry.timePeriod == .daily ? model.getTotalAmount(date: entry.date) : model.getTotalAmount(week: model.getDaysInWeek(date: entry.date))
                        
                        let goal = entry.timePeriod == .daily ? model.drinkData.dailyGoal : model.drinkData.dailyGoal*7
                        
                        Text("\(total, specifier: model.getSpecifier(amount: total)) / \(goal, specifier: model.getSpecifier(amount: model.drinkData.dailyGoal)) \(model.getUnits())")
                            .foregroundColor(.gray)
                            .accessibilityLabel("\(total, specifier: model.getSpecifier(amount: total)) out of \(goal, specifier: model.getSpecifier(amount: model.drinkData.dailyGoal)) \(model.getAccessibilityUnitLabel())")
                        
                    }
                    .frame(width: geo.size.width/2)
                    .accessibilityElement(children: .combine)
                    
                    Spacer()
                    
                }
                .frame(height: geo.size.height/3)
                .padding(.all, 10)
                .widgetURL(entry.timePeriod == .daily ? Constants.intakeDailyURL : Constants.intakeWeeklyURL)
                
                Divider()
                    .padding(.vertical, 10)
                
                // MARK: - Drink Type Detail
                let columns = Array(repeating: GridItem(.flexible(minimum: geo.size.width/4)), count: 2)
                
                let allTypes = model.drinkData.defaultDrinkTypes + model.drinkData.customDrinkTypes
                
                let nonZeroTypes = self.nonZeroTypes(types: allTypes)
                
                if !nonZeroTypes.isEmpty {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
                        if nonZeroTypes.count > 4 {
                            
                            let viewableTypes = [nonZeroTypes[0], nonZeroTypes[1], nonZeroTypes[2], nonZeroTypes[3]]
                            
                            ForEach(viewableTypes, id: \.self) { type in
                                VStack(alignment: .leading, spacing: 0) {
                                   Text(type)
                                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                        .bold()
                                        .font(getTypeNameFontStyle())
                                    
                                    let typeAmount = entry.timePeriod == .daily ? model.getDrinkTypeAmount(type: type, date: entry.date) : model.getDrinkTypeAmount(type: type, week: model.getDaysInWeek(date: entry.date))
                                    
                                    let typePercent = entry.timePeriod == .daily ? model.getDrinkTypePercent(type: type, date: entry.date) : model.getDrinkTypePercent(type: type, week: model.getDaysInWeek(date: entry.date))
                                    
                                    Text("\(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getUnits())")
                                        .font(getTypeInfoFontStyle())
                                        .accessibilityLabel("\(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getAccessibilityUnitLabel())")
                                                
                                    Text("\(typePercent*100, specifier: "%.2f")%")
                                        .font(getTypeInfoFontStyle())
                                        .accessibilityLabel("\(typePercent*100, specifier: "%.2f")%")
                                }
                                .padding(.horizontal, 10)
                                .padding(.bottom)
                                .accessibilityElement(children: .combine)
                            }
                        } else {
                            ForEach(nonZeroTypes, id: \.self) { type in
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(type)
                                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                        .bold()
                                        .font(getTypeNameFontStyle())
                                    
                                    let typeAmount = entry.timePeriod == .daily ? model.getDrinkTypeAmount(type: type, date: entry.date) : model.getDrinkTypeAmount(type: type, week: model.getDaysInWeek(date: entry.date))
                                    
                                    let typePercent = entry.timePeriod == .daily ? model.getDrinkTypePercent(type: type, date: entry.date) : model.getDrinkTypePercent(type: type, week: model.getDaysInWeek(date: entry.date))
                                    
                                    Text("\(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getUnits())")
                                        .font(getTypeInfoFontStyle())
                                        .accessibilityLabel("\(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getAccessibilityUnitLabel())")
                                            
                                    Text("\(typePercent*100, specifier: "%.2f")%")
                                        .font(getTypeInfoFontStyle())
                                        .accessibilityLabel("\(typePercent*100, specifier: "%.2f")%")

                                }
                                .padding(.horizontal, 10)
                                .padding(.bottom)
                                .accessibilityElement(children: .combine)

                            }
                        }
                    }
                    .widgetURL(entry.timePeriod == .daily ? Constants.intakeDailyURL : Constants.intakeWeeklyURL)
                    
                    Spacer()
                } else {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Text("Log a drink in the app to reach your \(entry.timePeriod == .daily ? "daily" : "weekly") goal.")
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .widgetURL(entry.timePeriod == .daily ? Constants.logDrinkDailyURL : Constants.logDrinkWeeklyURL)
                }
            }
        }
        .padding()
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
        if entry.timePeriod == .daily {
            // Loop through type index...
            for index in 0...typeIndex {
                // To get trim value for type
                progress += model.getDrinkTypePercent(type: drinkTypes[index], date: entry.date)
            }
            // If selectedTimePeriod is Week...
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
            return symbolSize
        } else if dynamicType > .xxxLarge && dynamicType < .accessibility3 {
            return symbolSize2
        } else if dynamicType > .accessibility2 && dynamicType < .accessibility5 {
            return symbolSize3
        } else {
            return symbolSize4
        }
    }
    
    private func getTypeNameFontStyle() -> Font {
        if dynamicType < .xLarge {
            return .body
        } else if dynamicType > .large && dynamicType < .xxxLarge {
            return .callout
        } else if dynamicType == .xxxLarge {
            return .footnote
        } else {
            return .caption2
        }
    }
    
    private func getTypeInfoFontStyle() -> Font {
        if dynamicType < .xLarge {
            return .subheadline
        } else if dynamicType > .large && dynamicType < .xxxLarge {
            return .caption
        } else if dynamicType == .xxxLarge {
            return .caption2
        } else if dynamicType > .xxxLarge && dynamicType < .accessibility3 {
            return Font.system(size: fontSize1)
        } else if dynamicType == .accessibility3 {
            return Font.system(size: fontSize2)
        } else if dynamicType == .accessibility4 {
            return Font.system(size: fontSize3)
        } else {
            return Font.system(size: fontSize4)
        }
    }
}
