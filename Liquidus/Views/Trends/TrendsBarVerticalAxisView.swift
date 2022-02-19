//
//  TrendsBarVerticalAxisView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 2/3/22.
//

import SwiftUI

struct TrendsBarVerticalAxisView: View {
    
    var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 1.5)
            
            Text(text)
                .foregroundColor(Color(.systemGray))
                .font(.caption)
        }
    }
}

struct TrendsBarVerticalLine_Previews: PreviewProvider {
    static var previews: some View {
        TrendsBarVerticalAxisView(text: "12A")
    }
}
