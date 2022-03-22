//
//  TrendsDetailTimePickerView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 2/4/22.
//

import SwiftUI

struct TrendsDetailTimePickerView: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    @Binding var binding: Constants.TimePeriod
    
    @State var hash = 0
    @Binding var touchLocation: Int
    
    var body: some View {
        
        Picker("Select Time Period", selection: $hash) {
            Text("D")
                .accessibilityLabel("Daily")
                .tag(Constants.TimePeriod.daily.hashValue)
            
            Text("W")
                .accessibilityLabel("Weekly")
                .tag(Constants.TimePeriod.weekly.hashValue)
            
            Text("M")
                .accessibilityLabel("Monthly")
                .tag(Constants.TimePeriod.monthly.hashValue)
            
            Text("6M")
                .accessibilityLabel("Half Yearly")
                .tag(Constants.TimePeriod.halfYearly.hashValue)
            
            Text("Y")
                .accessibilityLabel("Yearly")
                .tag(Constants.TimePeriod.yearly.hashValue)
        }
        .pickerStyle(SegmentedPickerStyle())
        .dynamicTypeSize(.large)
        .padding(.horizontal)
        .padding(.bottom, 16)
        .onAppear(perform: {
            hash = binding.hashValue
        })
        .onChange(of: hash, perform: { newValue in
            if reduceMotion {
                touchLocation = -1
                if newValue == Constants.TimePeriod.daily.hashValue {
                    binding = .daily
                } else if newValue == Constants.TimePeriod.weekly.hashValue {
                    binding = .weekly
                } else if newValue == Constants.TimePeriod.monthly.hashValue {
                    binding = .monthly
                } else if newValue == Constants.TimePeriod.halfYearly.hashValue {
                    binding = .halfYearly
                } else if newValue == Constants.TimePeriod.yearly.hashValue {
                    binding = .yearly
                }
            } else {
                withAnimation(.spring()) {
                    touchLocation = -1
                    if newValue == Constants.TimePeriod.daily.hashValue {
                        binding = .daily
                    } else if newValue == Constants.TimePeriod.weekly.hashValue {
                        binding = .weekly
                    } else if newValue == Constants.TimePeriod.monthly.hashValue {
                        binding = .monthly
                    } else if newValue == Constants.TimePeriod.halfYearly.hashValue {
                        binding = .halfYearly
                    } else if newValue == Constants.TimePeriod.yearly.hashValue {
                        binding = .yearly
                    }
                }
            }
        })
    }
}
