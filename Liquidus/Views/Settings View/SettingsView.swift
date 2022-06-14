//
//  SettingsView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI
import HealthKit
import WidgetKit

struct SettingsView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var drinks: FetchedResults<Drink>
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "order == 0")) var water: FetchedResults<DrinkType>
    
    @EnvironmentObject var model: DrinkModel
    
    @State var dailyGoal = ""
    
    @ScaledMetric(relativeTo: .body) var symbolSize = 20
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                // MARK: - Customization
                Section(header: Text("Customization")) {
                    
                    // Daily Goal
                    NavigationLink(
                        // Display Settings Page
                        destination: SettingsDailyGoalView(),
                        label: {
                            Label("Daily Goal", systemImage: "flag")
                        })
                    
                    // Drink Types
                    NavigationLink {
                        SettingsDrinkTypeView()
                    } label: {
                        Label {
                            Text("Drink Types")
                        } icon: {
                            Image("custom.drink")
                                .resizable()
                                .scaledToFit()
                                .frame(width: symbolSize, height: symbolSize)
                        }
                    }
                    
                    // Units
                    NavigationLink(
                        destination: SettingsUnitsView(),
                        label: {
                            Label("Units", systemImage: "ruler")
                        })
                    
                    
                }
                
                // MARK: - Debug
                Section(header: Text("Debug")) {
                    Button {
                        model.addYearDrinks()
                    } label: {
                        Label {
                            Text("Add a Year of Drinks")
                        } icon: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    Button {
                        for drink in drinks {
                            context.delete(drink)
                        }
                        
                        model.userInfo.dailyTotalToGoal = 0
                        
                        PersistenceController.shared.saveContext()
                        
                        WidgetCenter.shared.reloadAllTimelines()
                    } label: {
                        Label {
                            Text("Delete All Drinks")
                                .foregroundColor(.red)
                        } icon: {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                
                // MARK: - Apple Health
                // Don't display button if Apple Health access is granted
                if !model.userInfo.healthKitEnabled {
                    Section(header: Text("Apple Health")) {
                        
                        Button(action: {
                            if let healthStore = model.healthStore {
                                if model.userInfo.lastHKSave == nil {
                                    healthStore.requestAuthorization { succcess in
                                        if succcess {
                                            healthStore.getHealthKitData { statsCollection in
                                                if let statsCollection = statsCollection, let type = water.first {
                                                    if let drinks = type.drinks?.allObjects as? [Drink] {
                                                        
                                                        self.retrieveFromHealthKit(statsCollection, type: type)
                                                        
                                                        model.saveToHealthKit(allDrinks: drinks)
                                                        
                                                    } else {
                                                        self.retrieveFromHealthKit(statsCollection, type: type)
                                                    }
                                                
                                                    DispatchQueue.main.async {
                                                        model.userInfo.healthKitEnabled = true
                                                        model.saveUserInfo(test: false)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }, label: {
                            Label {
                                Text("Sync with Apple Health")
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "heart")
                                    .foregroundColor(Color(.systemPink))
                            }
                        })
                        
                    }
                }
                
                // MARK: - Other
                Section(header: Text("Other")) {
                    // About
                    NavigationLink(destination: SettingsAboutView()) {
                        Label("About", systemImage: "info.circle")
                    }
                    
                    // GitHub Repo
                    Link(destination: URL(string: "https://github.com/cengelbart39/Liquidus")!) {
                        Label {
                            Text("GitHub Repo")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "chevron.left.forwardslash.chevron.right")
                                .foregroundColor(Color(.systemBlue))
                        }
                    }
                    
                    // Development Journal
                    Link(destination: URL(string: "https://codecrew.codewithchris.com/t/christophers-healthkit-app-challenge-journal/14611")!) {
                        Label {
                            Text("Development Jorunal")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "book.closed")
                                .foregroundColor(Color(.systemBlue))
                        }
                    }
                }
                
            }
            .navigationBarTitle("Settings")
        }
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
                
                let drink = Drink(context: self.context)
                drink.id = UUID()
                drink.type = type
                drink.amount = amount
                drink.date = stats.startDate
                
                type.addToDrinks(drink)
                
                if let drinks = type.drinks?.allObjects as? [Drink] {
                    if drink.amount > 0 && !drinks.contains(drink) {
                        do {
                            try self.context.save()
                        } catch {
                            fatalError("SettingsView: retrieveFromHealthKit: \(error.localizedDescription)")
                        }
                    }
                
                } else {
                    if drink.amount > 0 {
                        do {
                            try self.context.save()
                        } catch {
                            fatalError("SettingsView: retrieveFromHealthKit: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(DrinkModel(test: false, suiteName: nil))
    }
}
