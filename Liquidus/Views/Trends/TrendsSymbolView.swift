//
//  TrendsSymbolView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 2/16/22.
//

import SwiftUI

struct TrendsSymbolView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.dynamicTypeSize) var dynamicType
    
    var type: String
    var avg1: Double?
    var avg2: Double?
    
    @ScaledMetric(relativeTo: .title3) var symbolSize1 = 40
    @ScaledMetric(relativeTo: .title3) var symbolSize2 = 30
    @ScaledMetric(relativeTo: .title3) var symbolSize3 = 20
    @ScaledMetric(relativeTo: .title3) var symbolSize4 = 10
    
    var body: some View {
        
        if let averageNow = avg1, let averageLastWeek = avg2 {
            if averageNow > averageLastWeek {
                Image(systemName: "chevron.up.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(type == Constants.totalKey ? model.getDrinkTypeGradient() : LinearGradient(colors: [model.getDrinkTypeColor(type: type)], startPoint: .top, endPoint: .bottom))
                    .frame(height: self.getSymbolSize())
                    .accessibilityLabel("Up Trend")
                
            } else if averageNow < averageLastWeek {
                Image(systemName: "chevron.down.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(type == Constants.totalKey ? model.getDrinkTypeGradient() : LinearGradient(colors: [model.getDrinkTypeColor(type: type)], startPoint: .top, endPoint: .bottom))
                    .frame(height: self.getSymbolSize())
                    .accessibilityLabel("Down Trend")
                
            } else if averageNow == averageLastWeek {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(type == Constants.totalKey ? model.getDrinkTypeGradient() : LinearGradient(colors: [model.getDrinkTypeColor(type: type)], startPoint: .top, endPoint: .bottom))
                    .frame(height: self.getSymbolSize())
                    .accessibilityLabel("No Trend")
            }
        } else {
            Image(systemName: "minus.circle.fill")
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(type == Constants.totalKey ? model.getDrinkTypeGradient() : LinearGradient(colors: [model.getDrinkTypeColor(type: type)], startPoint: .top, endPoint: .bottom))
                .frame(height: self.getSymbolSize())
                .accessibilityLabel("No Trend")
        }
    }
    
    /**
     Based on Dynamic Type Size, return one of the pre-defined @ScaledMetric properties
     */
    func getSymbolSize() -> Double {
        if !dynamicType.isAccessibilitySize {
            return symbolSize1
        } else if dynamicType == .accessibility1 {
            return symbolSize2
        } else if dynamicType == .accessibility2 || dynamicType == .accessibility3 {
            return symbolSize3
        } else {
            return symbolSize4
        }
    }
}
