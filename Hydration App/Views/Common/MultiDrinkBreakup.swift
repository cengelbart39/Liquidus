//
//  MultiDrinkBreakup.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/16/21.
//

import SwiftUI

struct MultiDrinkBreakup: View {
    
    var selectedTimePeriod: String
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                SingleDrinkBreakup(color: Constants.colors[Constants.waterKey]!, drinkType: Constants.waterKey, selectedTimePeriod: selectedTimePeriod)
                
                SingleDrinkBreakup(color: Constants.colors[Constants.sodaKey]!, drinkType: Constants.sodaKey, selectedTimePeriod: selectedTimePeriod)

            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                
                SingleDrinkBreakup(color: Constants.colors[Constants.coffeeKey]!, drinkType: Constants.coffeeKey, selectedTimePeriod: selectedTimePeriod)

                SingleDrinkBreakup(color: Constants.colors[Constants.juiceKey]!, drinkType: Constants.juiceKey, selectedTimePeriod: selectedTimePeriod)
                
            }
            
        }
        .padding(.horizontal)
        
    }
}
