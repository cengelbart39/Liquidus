//
//  IntakeCircularProgressBar.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI
import CoreData

struct IntakeCircularProgressBar: View {
    
    @State var fetchedResultsController: NSFetchedResultsController<DrinkType>?
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)], predicate: NSPredicate(format: "enabled == true"))
    var drinkTypes: FetchedResults<DrinkType>
    
    @FetchRequest(sortDescriptors: [])
    var drinks: FetchedResults<Drink>
    
    @EnvironmentObject var model: DrinkModel
    
    @AccessibilityFocusState private var isIntakeInfoFocused: Bool
    
    var day: Day
    @Binding var trigger: Bool
    
    var body: some View {
        
        ZStack {
            let types = drinkTypes.map { $0 }
            
            // Get total percentage of liquid consumed
            let totalPercent = model.getProgressPercent(types: types, day: day)
            
            IntakeCircularProgressDisplay(day: day, types: types, totalPercent: totalPercent, width: 30, trigger: $trigger)

            // If a day display the daily percent
            IntakeCircularProgressInfo(day: day, types: types, totalPercent: totalPercent, trigger: $trigger)
                .accessibilityFocused($isIntakeInfoFocused)
        }
        .padding(.horizontal)
        .multilineTextAlignment(.center)
        .onChange(of: drinks.count) { _ in
            isIntakeInfoFocused = true
        }
        .onChange(of: trigger) { newValue in
            trigger = newValue
        }
    }
}
