//
//  TrendsDetailDataListView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 2/13/22.
//

import SwiftUI

struct TrendsDetailDataListView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var type: DrinkType
    
    var body: some View {
        Form {
            let drinks = type.name == Constants.totalKey ? model.drinkData.drinks : model.drinkData.drinks.filter { $0.type == type }
            
            if drinks.count > 0 {
                Section(header: Text(model.drinkData.units)) {
                    ForEach(drinks.reversed()) { drink in
                        HStack {
                            Text("\(drink.amount, specifier: model.getSpecifier(amount: drink.amount))")
                            
                            Spacer()
                            
                            Text(getDateText(date: drink.date))
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
            } else {
                Section {
                    Text("No Data")
                }
            }
        }
        .navigationTitle("All Recorded Data")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /**
     Get date text in the form of "Apr 8, 2003"
     */
    private func getDateText(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        
        return formatter.string(from: date)
    }
}
