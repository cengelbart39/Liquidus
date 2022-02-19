//
//  TrendsBarHorizontalAxisView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 2/4/22.
//

import SwiftUI

struct TrendsBarHorizontalAxisView: View {
    var amount: String
    
    var body: some View {
        HStack {
            Rectangle()
                .foregroundColor(Color(.systemGray5))
                .frame(height: 1.5)
            
            Text(amount)
                .foregroundColor(Color(.systemGray5))
                .font(.subheadline)
        }
    }
}

struct TrendsBarHorizontalAxisView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsBarHorizontalAxisView(amount: "100")
    }
}
