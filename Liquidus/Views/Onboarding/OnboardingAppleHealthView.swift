//
//  OnboardingAppleHealthView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI
import HealthKit

struct OnboardingAppleHealthView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "order == 0"))
    var water: FetchedResults<DrinkType>
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var healthKitEnabled = false
    
    @ScaledMetric(relativeTo: .body) var imageSize = 75
    
    var body: some View {
        
        Form {
            Section {
                HStack {
                    Spacer ()
                    
                    Image(systemName: "heart.text.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize, height: imageSize)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(model.grayscaleEnabled ? .primary : .blue)
                    
                    Spacer()
                }
                .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                .listSectionSeparator(.hidden)
                .accessibilityHidden(true)
            }
            
            // Instructions
            Section {
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        Text("Liquidus can read and write water consumption data from Apple Health.\n")
                            .font(.title2)
                        
                        Text("You can always enable this later in the app's Settings.")
                            .font(.title3)
                    }
                    
                    Spacer()
                }
                .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                .listSectionSeparator(.hidden)
            }
            
            // Ask for Apple Health access and pull data if authorized
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
                                        
                                        healthKitEnabled = true
                                        
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
                HStack {
                    
                    Spacer()
                    
                    Text("Sync with Apple Health")
                        .foregroundColor(.pink)
                    
                    Spacer()
                }
            })
        }
        .multilineTextAlignment(.center)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Update and save onboarding status
                    model.userInfo.isOnboarding = false
                    model.saveUserInfo(test: false)
                } label: {
                    if healthKitEnabled {
                        Text("Done")
                    } else {
                        Text("Skip")
                    }
                }
            }
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
                
                let context = PersistenceController.shared.container.viewContext
                
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

struct OnboardingAppleHealthView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingAppleHealthView()
                .environmentObject(DrinkModel(test: false, suiteName: nil))
            OnboardingAppleHealthView()
                .preferredColorScheme(.dark)
                .environmentObject(DrinkModel(test: false, suiteName: nil))
        }
    }
}
