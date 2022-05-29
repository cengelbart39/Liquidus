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
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    var shapes = ["circle", "square", "triangle", "diamond"]
    
    var entry: SimpleEntry
    
    @State var hiddenTrigger = false
    
    var body: some View {
        let nonZeroTypes = self.nonZeroTypes()
        
        GeometryReader { geo in
            VStack(spacing: 5) {
                
                HStack {
                    
                    Spacer()
                    
                    let day = Day(date: entry.date)
                    let week = Week(date: entry.date)
                    
                    // MARK: - Circular Progress Bar
                    if entry.timePeriod == .daily {
                        IntakeCircularProgressDisplay(
                            timePeriod: .daily,
                            datePeriod: day,
                            totalPercent: model.getProgressPercent(type: model.drinkData.drinkTypes.last!, dates: day),
                            width: 20,
                            trigger: $hiddenTrigger
                        )
                        .frame(maxWidth: geo.size.width/2)
                        .accessibilityHidden(true)
                        .padding(.top, 21)
                        .padding(.bottom, 10)
                        .widgetURL(Constants.intakeDailyURL)
                    
                    } else if entry.timePeriod == .weekly {
                        IntakeCircularProgressDisplay(
                            timePeriod: .weekly,
                            datePeriod: week,
                            totalPercent: model.getProgressPercent(type: model.drinkData.drinkTypes.last!, dates: week),
                            width: 20,
                            trigger: $hiddenTrigger
                        )
                        .frame(maxWidth: geo.size.width/2)
                        .accessibilityHidden(true)
                        .padding(.top, 21)
                        .padding(.bottom, 10)
                        .widgetURL(Constants.intakeWeeklyURL)
                        
                    }
                    
                    Spacer()
                        .frame(width: 20)
                    
                    // MARK: - Total Info
                    VStack(alignment: .leading, spacing: 5) {
                        let percent = entry.timePeriod == .daily ? model.getTotalPercentByDay(day: day) : model.getTotalPercentByWeek(week: week)
                        
                        Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                            .font(.title)
                            .bold()
                            .accessibilityLabel("\(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0)) of Goal")
                            .padding(.bottom, -2)
                            .dynamicTypeSize(.xSmall ... .xxLarge)
                        
                        let c1 = Array(repeating: GridItem(.flexible(maximum: geo.size.width/2)), count: 2)
                        
                        if let first = self.getFirstFourTypes(types: nonZeroTypes) {
                        
                            LazyVGrid(columns: c1, alignment: .leading, spacing: 2) {
                                
                                ForEach(first, id: \.self) { type in
                                    
                                    let typeAmount = entry.timePeriod == .daily ? model.getTypeAmountByDay(type: type, day: day) : model.getTypeAmountByWeek(type: type, week: week)
                                    
                                    if (differentiateWithoutColor) {
                                        
                                        HStack {
                                            Image(systemName: shapes[first.firstIndex(of: type)!])
                                                .symbolVariant(.fill)
                                                .font(.caption.weight(.bold))
                                                .accessibilityHidden(true)
                                            
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text("\(typeAmount, specifier: model.getSpecifier(amount: typeAmount))")
                                                    .bold()
                                                    .font(differentiateWithoutColor ? .caption : .subheadline)

                                                Text(model.getUnits().uppercased())
                                                    .font(differentiateWithoutColor ? .caption : .subheadline)
                                                    .bold()
                                            }
                                        }
                                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                        .dynamicTypeSize(.xSmall ... .xLarge)
                                        .accessibilityLabel("\(type.name), \(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getAccessibilityUnitLabel())")
                                         
                                        
                                    } else {
                                        Group {
                                            Text("\(typeAmount, specifier: model.getSpecifier(amount: typeAmount))")
                                                .font(.subheadline)
                                                .bold()
                                            + Text(model.getUnits().uppercased())
                                                .font(.footnote)
                                                .bold()
                                        }
                                        .foregroundColor(model.grayscaleEnabled ? .primary : model.getDrinkTypeColor(type: type))
                                        .dynamicTypeSize(.xSmall ... .xxLarge)
                                        .accessibilityLabel("\(type.name), \(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getAccessibilityUnitLabel())")
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    .frame(width: geo.size.width/1.6)
                    
                    Spacer()
                    
                }
                .frame(height: geo.size.height/3)
                .padding(.all, 10)
                .widgetURL(entry.timePeriod == .daily ? Constants.intakeDailyURL : Constants.intakeWeeklyURL)
                
                Divider()
                    .padding(.bottom, 10)
                
                // MARK: - Drink Type Detail
                let c2 = Array(repeating: GridItem(.flexible(maximum: geo.size.width/2.1)), count: 2)
                
                if let first = self.getFirstFourTypes(types: nonZeroTypes) {
                    
                    let max = self.getMaxDataType(types: first)
                    
                    LazyVGrid(columns: c2, alignment: .leading, spacing: 10) {
                        
                        ForEach(first, id: \.self) { type in
                            
                            WidgetChartView(entry: entry, type: type, maxVal: max, shape: shapes[first.firstIndex(of: type)!])
                                .frame(height: geo.size.height/4.2)
                                .dynamicTypeSize(differentiateWithoutColor ? .xSmall ... .xLarge : .xSmall ... .xxLarge)
                            
                        }
                        
                    }
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
    
    /**
     Get the first four elements of a `DrinkType` array
     - Parameter types: A `DrinkType` array
     - Returns: A `DrinkType` array with the first four `DrinkType`s; `nil` if `types` is empty
     */
    private func getFirstFourTypes(types: [DrinkType]) -> [DrinkType]? {
        let t = types.prefix(4)
        
        if t == ArraySlice([]) {
            return nil
            
        } else {
            return Array(t)
            
        }
    }
    
    /**
      Filters out `DrinkType`s based on if the user has consumed any `Drink`s and sorts by the greatest amount
      - Returns: The `DrinkType`s that the user have consumed a `Drink` in
     */
    private func nonZeroTypes() -> [DrinkType] {
        var nonZeroTypes = [DrinkType]()
        
        // Get a Day for entry.date
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
     Get the maximum amount of the `DrinkType` with the greater amount consumed during `entry.date`
     - Parameter types: A 24element or less `DrinkType` array
     - Precondition: Assumes `types` is a 4-element, or less, array
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
