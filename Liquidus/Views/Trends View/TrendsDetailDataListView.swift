//
//  TrendsDetailDataListView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 2/13/22.
//

import SwiftUI

struct TrendsDetailDataListView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date", ascending: true)], predicate: NSPredicate(format: "type.enabled == true")) var allDrinks: FetchedResults<Drink>
    
    @EnvironmentObject var model: DrinkModel
    
    var type: DrinkType?
    
    var drinks: FetchedResults<Drink> {
        let descriptor = NSSortDescriptor(key: "date", ascending: true)
        
        if let type = type {
            let predicate = NSPredicate(format: "type == %@", type)
            
            let request = FetchRequest<Drink>(entity: Drink.entity(), sortDescriptors: [descriptor], predicate: predicate)
            
            return request.wrappedValue
        
        } else {
            let predicate = NSPredicate(format: "type.enabled == true")
            
            let request = FetchRequest<Drink>(entity: Drink.entity(), sortDescriptors: [descriptor], predicate: predicate)
            
            return request.wrappedValue
        }
    }
    
    var body: some View {
        Form {
            if drinks.count > 0 {
                Section(header: Text(model.userInfo.units)) {
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
        .navigationTitle(type != nil ? "All Recorded \(type!.name) Data" : "All Recorded Data")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /**
     Get a formatted String representation of a date
     - Parameter date: A Date to format a String to
     - Returns: A String formatted as "April 8, 2003"
     */
    private func getDateText(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        
        return formatter.string(from: date)
    }
}
