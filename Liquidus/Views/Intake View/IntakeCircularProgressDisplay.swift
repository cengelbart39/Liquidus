//
//  IntakeCircularProgressDisplay.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 3/23/22.
//
//  Based off of:
//  https://www.simpleswiftguide.com/how-to-build-a-circular-progress-bar-in-swiftui/
//

import SwiftUI

struct IntakeCircularProgressDisplay: View {
    
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var model: DrinkModel
    
    var day: Day
    var types: [DrinkType]
    var totalPercent: Double
    var width: CGFloat
    @Binding var trigger: Bool
    
    var body: some View {
        
        ZStack {
            // Create circle background
            Circle()
                .stroke(lineWidth: width)
                .foregroundColor(Color(.systemGray6))
                .scaledToFit()
            
            // Get the outline fill for each type
            ForEach(0..<types.count, id: \.self) { index in
                
                let prefix = spliceTypesArray(index: types.count-index)
                
                // Get color for highlight
                // Use drink type color if goal isn't reached
                // Use "GoalGreen" if goal is reached
                let color = model.getHighlightColor(types: prefix, day: day)
                    
                IntakeCircularProgressBarHighlight(progress: model.getProgressPercent(types: prefix, day: day), color: color, width: width, trigger: $trigger)
            }
        }
    }
    
    func spliceTypesArray(index: Int) -> [DrinkType] {
        let prefix = self.types.prefix(index)
        
        return Array(prefix)
    }
}
