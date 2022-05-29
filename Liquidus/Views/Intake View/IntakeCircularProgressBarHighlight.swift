//
//  IntakeCircularProgressBarHighlight.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct IntakeCircularProgressBarHighlight: View {
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var progress: Double
    var color: Color
    var width: CGFloat
    @Binding var trigger: Bool
    
    var body: some View {
        
        // Create a trimmed circular outline
        Circle()
            .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
            .stroke(style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
            .foregroundColor(color)
            .rotationEffect(Angle(degrees: 270.0))
            .animation(reduceMotion ? .none : .linear, value: progress)
            .onChange(of: trigger) { newValue in
                trigger = newValue
            }
    }
}
