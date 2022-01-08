//
//  IntakeTimePickerView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct IntakeTimePickerView: View {
    
    @Binding var picker: String
    
    var body: some View {
        
        Picker("Select Time Period", selection: $picker) {
            Text(Constants.selectDay)
                .tag(Constants.selectDay)
            
            Text(Constants.selectWeek)
                .tag(Constants.selectWeek)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
        .padding(.bottom, 16)
        
    }
}
