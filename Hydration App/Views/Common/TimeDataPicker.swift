//
//  TimeDataPicker.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct TimeDataPicker: View {
    
    var body: some View {
        
        HStack {
            Image(systemName: "chevron.left")
                .foregroundColor(.red)
            
            Spacer()
            
            Text("September 6, 2021")
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.red)
        }
        .padding(.horizontal)
        .padding(.bottom, 6)
    }
}

struct TimeDataPicker_Previews: PreviewProvider {
    static var previews: some View {
        TimeDataPicker()
    }
}
