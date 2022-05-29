//
//  TrendsDetailChartBarView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 1/24/22.
//

import SwiftUI

struct TrendsDetailChartBarView: View {
    @EnvironmentObject var model: DrinkModel
    
    var item: DataItem
    var value: Double
    var type: DrinkType
    var isWidget: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: isWidget ? 4 : 8)
            .fill(self.getFill())
            .scaleEffect(CGSize(width: 1, height: value), anchor: .bottom)
    }
    
    /**
     Returns an appropriate fill for a Rounded Rectangle
     - Returns: A solid gradient or a rainbow gradient, dependent on if grayscale is enabled and the value of `self.type`
     */
    func getFill() -> LinearGradient {
        if model.grayscaleEnabled {
            return LinearGradient(colors: [.primary], startPoint: .top, endPoint: .bottom)
            
        } else if type.name == Constants.totalKey {
            return model.getDrinkTypeGradient()
            
        } else {
            return LinearGradient(colors: [model.getDrinkTypeColor(type: type)], startPoint: .top, endPoint: .bottom)
        }
    }
}
