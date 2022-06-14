//
//  TabBar.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI
import HealthKit

struct TabBar: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "order == 0")) var water: FetchedResults<DrinkType>
    
    @EnvironmentObject var model: DrinkModel
    
    @State var selectedTab = 0
    
    @State var hiddenTrigger = false
    
    @State var isLogDrinkViewShowing = false
    
    @State var updateButtons = false
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            // IntakeView
            IntakeView(hiddenTrigger: $hiddenTrigger, updateButtons: updateButtons)
                .tabItem {
                    VStack {
                        Image("custom.drink.fill")
                            .font(.system(size: 25))

                        Text("Intake")
                    }
                }
                .tag(0)
            
            // TrendsView
            TrendsView()
                .tabItem {
                    VStack {
                        Image(systemName: "chart.bar")
                        Text("Trends")
                    }
                }
                .tag(1)
            
            // SettingsView
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                }
                .tag(2)
        }
        .onOpenURL(perform: { url in
            if url == Constants.intakeURL {
                selectedTab = 0
            } else if url == Constants.logDrinkURL {
                selectedTab = 0
                isLogDrinkViewShowing = true
                updateButtons = true
            }
        })
        .sheet(isPresented: $isLogDrinkViewShowing, content: {
            // Show IntakeLogDrinkView
            IntakeLogDrinkView(isPresented: $isLogDrinkViewShowing, trigger: $hiddenTrigger)
                .environmentObject(model)
                .onDisappear {
                    updateButtons = false
                }

        })
        .onAppear {
            // If water is enabled...
            if self.waterEnabled() && model.userInfo.healthKitEnabled {
                // If healthStore exists and does app have access...
                if model.healthStore?.healthStore != nil && HKHealthStore.isHealthDataAvailable() {
                    // Get statsCollections
                    model.healthStore!.getHealthKitData { statsCollection in
                        // Retrieve HealthKit data
                        if let statsCollection = statsCollection, let type = water.first {
                            self.retrieveFromHealthKit(statsCollection, type: type)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    /**
     Checks if the Water DrinkType is enabled
     - Returns: True if enabled; False if not
     */
    func waterEnabled() -> Bool {
        if let water = water.first {
            return water.enabled
        }
        
        return false
    }
    
    /**
     Retrieve data from HealthKit
     - Parameters:
        - statsCollection: The data extracted from Apple Health
        - type: The `DrinkType` to save the new `Drink` to
     - Precondition: Liquidus can only be granted permission to read and write Water consumption data from HealthKit. The assumption is the passed in `DrinkType` is Water.
     */
    func retrieveFromHealthKit(_ statsCollection: HKStatisticsCollection, type: DrinkType) {
        
        // Get start and end date
        let startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let endDate = Date()
        
        // Go through every date pulled from HealthKit
        statsCollection.enumerateStatistics(from: startDate, to: endDate) { stats, stop in
            
            // Get the summed amount converted to unit based on user preference
            if let amount = stats.sumQuantity()?.doubleValue(for: model.getHKUnit()) {

                let drink = Drink(context: context)
                drink.id = UUID()
                drink.type = type
                drink.amount = amount
                drink.date = stats.startDate
                
                type.addToDrinks(drink)
                
                if let drinks = type.drinks?.allObjects as? [Drink] {
                    if drink.amount > 0 && !drinks.contains(drink) {
                        PersistenceController.shared.saveContext()
                    }
                
                } else {
                    if drink.amount > 0 {
                        PersistenceController.shared.saveContext()

                    }
                }
            }
        }
    }

}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
            .environmentObject(DrinkModel(test: false, suiteName: nil))
    }
}
