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
    
    var body: some View {
        let drinkTypes = model.drinkData.defaultDrinkTypes + model.drinkData.customDrinkTypes
        
        let nonZeroTypes = self.nonZeroTypes(types: drinkTypes)
        
        GeometryReader { geo in
            VStack(spacing: 5) {
                
                HStack {
                    
                    Spacer()
                    
                    // MARK: - Circular Progress Bar
                    IntakeCircularProgressDisplay(
                        timePeriod: entry.timePeriod,
                        day: .now,
                        week: model.getDaysInWeek(date: .now),
                        drinkTypes: drinkTypes,
                        totalPercent: model.getProgressPercent(
                            type: drinkTypes.last!,
                            dates: entry.timePeriod == .daily ? Date.now : model.getDaysInWeek(date: .now)),
                        width: 20
                    )
                    .frame(maxWidth: geo.size.width/2)
                    .accessibilityHidden(true)
                    .padding(.top, 21)
                    .padding(.bottom, 10)
                    .widgetURL(entry.timePeriod == .daily ? Constants.intakeDailyURL : Constants.intakeWeeklyURL)
                    
                    Spacer()
                        .frame(width: 20)
                    
                    // MARK: - Total Info
                    VStack(alignment: .leading, spacing: 5) {
                        let percent = entry.timePeriod == .daily ? model.getTotalPercentByDay(date: entry.date) : model.getTotalPercentByWeek(week: model.getDaysInWeek(date: entry.date))
                        
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
                                    
                                    let typeAmount = entry.timePeriod == .daily ? model.getTypeAmountByDay(type: type, date: .now) : model.getTypeAmountByWeek(type: type, week: model.getDaysInWeek(date: .now))
                                    
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
                                        .accessibilityLabel("\(type), \(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getAccessibilityUnitLabel())")
                                         
                                        
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
                                        .accessibilityLabel("\(type), \(typeAmount, specifier: model.getSpecifier(amount: typeAmount)) \(model.getAccessibilityUnitLabel())")
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
    
    private func getFirstFourTypes(types: [String]) -> [String]? {
        let t = types.prefix(4)
        
        if t == ArraySlice([]) {
            return nil
            
        } else {
            return Array(t)
            
        }
    }
    
    // Filters out drink types based on if the user has consumed any
    // Then sorts by the greatest amount
    private func nonZeroTypes(types: [String]) -> [String] {
        var nonZeroTypes = [String]()
        
        for type in types {
            if model.getTypeAmountByDay(type: type, date: entry.date) > 0.0 {
                nonZeroTypes.append(type)
            }
        }
        
        if !nonZeroTypes.isEmpty {
            nonZeroTypes.sort { model.getTypeAmountByDay(type: $0, date: entry.date) > model.getTypeAmountByDay(type: $1, date: entry.date) }
        }
        
        return nonZeroTypes
    }
    
    private func getMaxDataType(types: [String]) -> Double {
        var maxes = [Double]()
        
        for type in types {
            let dataItems = entry.timePeriod == .daily ? model.getDataItemsForDay(date: .now, type: type) : model.getDataItemsForWeek(week: model.getDaysInWeek(date: .now), type: type)
            
            maxes.append(model.getMaxValue(dataItems: dataItems, timePeriod: entry.timePeriod))
        }
        
        return maxes.max()!
    }

}
