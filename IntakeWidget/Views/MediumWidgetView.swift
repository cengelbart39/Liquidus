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
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    var entry: SimpleEntry
    
    var shapes = ["circle", "square", "triangle", "diamond"]
    
    @State var hiddenTrigger = false
    
    @ScaledMetric(relativeTo: .footnote) var symbolSize1 = 15
    @ScaledMetric(relativeTo: .footnote) var symbolSize2 = 10
    @ScaledMetric(relativeTo: .footnote) var symbolSize3 = 7
    
    var body: some View {
        let nonZeroTypes = self.nonZeroTypes()
        
        GeometryReader { geo in
            HStack {
                
                VStack(alignment: .leading) {
                    
                    let day = Day(date: entry.date)
                    let week = Week(date: entry.date)
                    
                    // MARK: - Circular Progress Bar
                    if entry.timePeriod == .daily {
                        IntakeCircularProgressDisplay(
                            timePeriod: .daily,
                            datePeriod: day,
                            totalPercent: model.getProgressPercent(type: model.drinkData.drinkTypes.last!, dates: day),
                            width: 13,
                            trigger: $hiddenTrigger
                        )
                        .accessibilityHidden(true)
                        .padding(.top, 21)
                        .padding(.bottom, 10)
                        .widgetURL(Constants.intakeDailyURL)
                        .frame(maxWidth: geo.size.width/5)
                        .frame(maxHeight: 2*geo.size.height/2)
                        
                    } else if entry.timePeriod == .weekly {
                        IntakeCircularProgressDisplay(
                            timePeriod: .weekly,
                            datePeriod: week,
                            totalPercent: model.getProgressPercent(type: model.drinkData.drinkTypes.last!, dates: week),
                            width: 13,
                            trigger: $hiddenTrigger
                        )
                        .accessibilityHidden(true)
                        .padding(.top, 21)
                        .padding(.bottom, 10)
                        .widgetURL(Constants.intakeWeeklyURL)
                        .frame(maxWidth: geo.size.width/5)
                        .frame(maxHeight: 2*geo.size.height/2)
                    }
                    
                    
                    Spacer()
                    
                    let percent = entry.timePeriod == .daily ? model.getTotalPercentByDay(day: day) : model.getTotalPercentByWeek(week: week)
                    
                    Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                        .font(.title3)
                        .bold()
                        .accessibilityLabel("\(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0)) of Goal")
                        .accessibilitySortPriority(2)
                    
                    if let first = self.getFirstTwoTypes(types: nonZeroTypes) {
                    
                        ForEach(first, id: \.self) { type in
                            
                            let typeAmount = entry.timePeriod == .daily ? model.getTypeAmountByDay(type: type, day: day) : model.getTypeAmountByWeek(type: type, week: week)
                            
                            HStack {
                            
                                if (differentiateWithoutColor) {
                                    Image(systemName: shapes[first.firstIndex(of: type)!])
                                        .symbolVariant(.fill)
                                        .font(.subheadline.weight(.bold))
                                        .accessibilityHidden(true)
                                }
                                
                                Group {
                                    Text("\(typeAmount, specifier: model.getSpecifier(amount: typeAmount))")
                                        .font(.body)
                                        .bold()
                                    
                                    + Text(model.getUnits().uppercased())
                                        .font(.callout)
                                        .bold()
                                }
                            }
                            .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                            .accessibilityLabel("\(type.name), \(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getAccessibilityUnitLabel())")
                            .accessibilitySortPriority(1)

                        }
                    }
                }
                .padding(.bottom, 5)
                .padding(.leading, 15)
                
                Spacer()
                
                // MARK: - Drink Type Detail
                VStack(alignment: .leading, spacing: 5) {
                    
                    if let viewableTypes = self.getFirstTwoTypes(types: nonZeroTypes) {
                        
                        let max = self.getMaxDataType(types: viewableTypes)
                        
                        ForEach(viewableTypes, id: \.self) { type in
                            
                            WidgetChartView(entry: entry, type: type, maxVal: max, shape: shapes[viewableTypes.firstIndex(of: type)!])
                        }
                        .accessibilitySortPriority(0)
                    } else {
                        
                        VStack {
                            
                            Spacer()
                            
                            Text("Log a drink in the app to reach your \(entry.timePeriod == .daily ? "daily" : "weekly") goal.")
                                .font(.body)
                            
                            Spacer()
                        }
                        .accessibilitySortPriority(0)
                        .widgetURL(entry.timePeriod == .daily ? Constants.logDrinkDailyURL : Constants.logDrinkWeeklyURL)
                        
                    }
                }
                .padding(.vertical, 10)
                .padding(.trailing)
                .frame(width: geo.size.width/2)
                
            }
            .dynamicTypeSize(.xSmall ... .xxLarge)
        }
    }
    
    /**
     Filters out `DrinkType`s based on if the user has consumed any `Drink`s and sorts by the greatest amount
     - Returns: The `DrinkType`s that the user have consumed a `Drink` in
     */
    private func nonZeroTypes() -> [DrinkType] {
        // Create a DrinkType array
        var nonZeroTypes = [DrinkType]()
        
        // Get a Day
        let day = Day(date: entry.date)
        
        // Loop through all DrinkTypes
        for type in model.drinkData.drinkTypes {
            
            // Append to nonZeroTypes if any Drinks of type were consumed
            if model.getTypeAmountByDay(type: type, day: day) > 0.0 {
                nonZeroTypes.append(type)
            }
        }
        
        // If nonZeroTypes isn't empty
        if !nonZeroTypes.isEmpty {
            
            // Sort by the greatest amount consumed on day
            nonZeroTypes.sort {
                model.getTypeAmountByDay(type: $0, day: day) > model.getTypeAmountByDay(type: $1, day: day)
            }
        }
        
        return nonZeroTypes
    }
    
    /**
     Get the first two elements of a `DrinkType` array
     - Parameter types: A `DrinkType` array
     - Returns: A `DrinkType` array with the first two `DrinkType`s; `nil` if `types` is empty
     */
    private func getFirstTwoTypes(types: [DrinkType]) -> [DrinkType]? {
        // Get the Array Slice
        let t = types.prefix(2)
        
        // If it is empty, return nil
        if t == ArraySlice([]) {
            return nil
            
        // Otherwise cast to Array and return
        } else {
            return Array(t)
            
        }
    }
    
    /**
     Based on Dynamic Type Size, return the appropriate symbol size
     - Returns: The appropriate symbol size
     */
    private func getSymbolSize() -> Double {
        if !dynamicType.isAccessibilitySize {
            return symbolSize1
            
        } else if dynamicType > .xxxLarge && dynamicType < .accessibility3 {
            return symbolSize2
            
        } else {
            return symbolSize3
        }
    }
    
    /**
     Get the maximum amount of the `DrinkType` with the greater amount consumed during `entry.date`
     - Parameter types: A 2-element or less `DrinkType` array
     - Precondition: Assumes `types` is a 2-element, or less, array
     - Returns: The maximum amount of the `DrinkType` with the greater amount consumed during `entry.date`
     */
    private func getMaxDataType(types: [DrinkType]) -> Double {
        var maxes = [Double]()
        
        // Get a Day and Week
        let day = Day(date: entry.date)
        let week = Week(date: entry.date)
        
        // Loop through types
        for type in types {
            
            // Get the DataItems by Day or Week depending on timePeriod
            let dataItems = entry.timePeriod == .daily ? model.getDataItemsForDay(day: day, type: type) : model.getDataItemsForWeek(week: week, type: type)
            
            // Append the maxValue of the DataItems
            maxes.append(model.getMaxValue(dataItems: dataItems, timePeriod: entry.timePeriod))
        }
        
        // Return the max of the maxes array
        return maxes.max()!
    }
}
