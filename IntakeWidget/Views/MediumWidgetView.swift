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
    
    @ScaledMetric(relativeTo: .footnote) var symbolSize1 = 15
    @ScaledMetric(relativeTo: .footnote) var symbolSize2 = 10
    @ScaledMetric(relativeTo: .footnote) var symbolSize3 = 7
    
    var body: some View {
        let nonZeroTypes = self.nonZeroTypes()
        
        GeometryReader { geo in
            HStack {
                
                VStack(alignment: .leading) {
                    
                    // MARK: - Circular Progress Bar
                    IntakeCircularProgressDisplay(
                        timePeriod: entry.timePeriod,
                        day: .now,
                        week: model.getDaysInWeek(date: .now),
                        totalPercent: model.getProgressPercent(
                            type: model.drinkData.drinkTypes.last!,
                            dates: entry.timePeriod == .daily ? Date.now : model.getDaysInWeek(date: .now)),
                        width: 13
                    )
                    .accessibilityHidden(true)
                    .padding(.top, 21)
                    .padding(.bottom, 10)
                    .widgetURL(entry.timePeriod == .daily ? Constants.intakeDailyURL : Constants.intakeWeeklyURL)
                    .frame(maxWidth: geo.size.width/5)
                    .frame(maxHeight: 2*geo.size.height/2)
                    
                    Spacer()
                    
                    let percent = entry.timePeriod == .daily ? model.getTotalPercentByDay(date: entry.date) : model.getTotalPercentByWeek(week: model.getDaysInWeek(date: entry.date))
                    
                    Text(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0))
                        .font(.title3)
                        .bold()
                        .accessibilityLabel("\(String(format: "\(model.getSpecifier(amount: percent*100))%%", percent*100.0)) of Goal")
                        .accessibilitySortPriority(2)
                    
                    if let first = self.getFirstTwoTypes(types: nonZeroTypes) {
                    
                        ForEach(first, id: \.self) { type in
                            
                            let typeAmount = entry.timePeriod == .daily ? model.getTypeAmountByDay(type: type, date: entry.date) : model.getTypeAmountByWeek(type: type, week: model.getDaysInWeek(date: entry.date))
                            
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
    
    // Filters out drink types based on if the user has consumed any
    // Then sorts by the greatest amount
    private func nonZeroTypes() -> [DrinkType] {
        var nonZeroTypes = [DrinkType]()
        
        for type in model.drinkData.drinkTypes {
            if model.getTypeAmountByDay(type: type, date: entry.date) > 0.0 {
                nonZeroTypes.append(type)
            }
        }
        
        if !nonZeroTypes.isEmpty {
            nonZeroTypes.sort { model.getTypeAmountByDay(type: $0, date: entry.date) > model.getTypeAmountByDay(type: $1, date: entry.date) }
        }
        
        return nonZeroTypes
    }
    
    private func getFirstTwoTypes(types: [DrinkType]) -> [DrinkType]? {
        let t = types.prefix(2)
        
        if t == ArraySlice([]) {
            return nil
            
        } else {
            return Array(t)
            
        }
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
    
    private func getMaxDataType(types: [DrinkType]) -> Double {
        var maxes = [Double]()
        
        for type in types {
            let dataItems = entry.timePeriod == .daily ? model.getDataItemsForDay(date: .now, type: type) : model.getDataItemsForWeek(week: model.getDaysInWeek(date: .now), type: type)
            
            maxes.append(model.getMaxValue(dataItems: dataItems, timePeriod: entry.timePeriod))
        }
        
        return maxes.max()!
    }
}
