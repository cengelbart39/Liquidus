//
//  RectangleCard.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct RectangleCard: View {
    
    var color: Color
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(color)
        
    }
}
