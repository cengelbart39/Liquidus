//
//  IntakeMultiDrinkBreakup.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/16/21.
//

import SwiftUI

struct IntakeMultiDrinkBreakup: View {
    
    var selectedTimePeriod: String
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                IntakeSingleDrinkBreakup(color: Constants.colors[Constants.waterKey]!, drinkType: Constants.waterKey, selectedTimePeriod: selectedTimePeriod)
                
                IntakeSingleDrinkBreakup(color: Constants.colors[Constants.sodaKey]!, drinkType: Constants.sodaKey, selectedTimePeriod: selectedTimePeriod)

            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                
                IntakeSingleDrinkBreakup(color: Constants.colors[Constants.coffeeKey]!, drinkType: Constants.coffeeKey, selectedTimePeriod: selectedTimePeriod)

                IntakeSingleDrinkBreakup(color: Constants.colors[Constants.juiceKey]!, drinkType: Constants.juiceKey, selectedTimePeriod: selectedTimePeriod)
                
            }
            
        }
        .padding(.horizontal)
        
    }
}
