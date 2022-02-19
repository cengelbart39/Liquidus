//
//  TrendsAmountView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 2/16/22.
//

import SwiftUI

struct TrendsAmountView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.dynamicTypeSize) var dynamicType
    
    var type: String
    var avg1: Double?
    
    var body: some View {
        let units = "\(model.getUnits())/day"
        
        if avg1 != nil {
            Group {
                Text("\(avg1!, specifier: model.getSpecifier(amount: avg1!))")
                    .bold()
                    .font(self.getAmountFontStyle())
                + Text(units.uppercased())
                    .bold()
                    .font(self.getUnitFontStyle())
                    .accessibilityLabel("\(model.getAccessibilityUnitLabel()) per day")
            }
            .foregroundStyle(type == Constants.allKey ? model.getDrinkTypeGradient() : LinearGradient(colors: [model.getDrinkTypeColor(type: type)], startPoint: .top, endPoint: .bottom))
            
        } else {
            Group {
                Text("-/-")
                    .bold()
                    .font(self.getAmountFontStyle())
                + Text(units.uppercased())
                    .bold()
                    .font(self.getUnitFontStyle())
            }
            .foregroundStyle(type == Constants.allKey ? model.getDrinkTypeGradient() : LinearGradient(colors: [model.getDrinkTypeColor(type: type)], startPoint: .top, endPoint: .bottom))
            .accessibilityLabel("Not Enough Data")
        }
    }
    
    /**
     Based on Dynamic Type Size return a font style
     */
    func getAmountFontStyle() -> Font {
        if !dynamicType.isAccessibilitySize {
            return .title2
        } else if dynamicType == .accessibility1 {
            return .body
        } else if dynamicType == .accessibility2 || dynamicType == .accessibility3 {
            return .subheadline
        } else {
            return .caption2
        }
    }
    
    /**
     Based on Dynamic Type Size return a font style or size
     */
    func getUnitFontStyle() -> Font {
        if !dynamicType.isAccessibilitySize {
            return .subheadline
        } else if dynamicType == .accessibility1 {
            return .caption
        } else if dynamicType == .accessibility2 || dynamicType == .accessibility3 {
            return .caption2
        } else {
            return .system(size: 25)
        }
    }
}
