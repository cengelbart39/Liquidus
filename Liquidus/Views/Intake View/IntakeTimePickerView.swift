//
//  IntakeTimePickerView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct IntakeTimePickerView: View {
    
    @Binding var picker: Constants.TimePeriod
    
    @State var hash = 0
    
    var body: some View {
        
        Picker("Select Time Period", selection: $hash) {
            Text(Constants.selectDay)
                .tag(Constants.TimePeriod.daily.hashValue)
            
            Text(Constants.selectWeek)
                .tag(Constants.TimePeriod.weekly.hashValue)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
        .padding(.bottom, 16)
        .onAppear(perform: {
            hash = picker.hashValue
        })
        .onChange(of: hash, perform: { newValue in
            if newValue == Constants.TimePeriod.daily.hashValue {
                picker = .daily
            } else {
                picker = .weekly
            }
        })
    }
}
