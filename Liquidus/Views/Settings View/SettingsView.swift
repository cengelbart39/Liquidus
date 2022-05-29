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
                        model.drinkData.drinks = [Drink]()
                        
                        model.save(test: false)
                        
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
                if !model.drinkData.healthKitEnabled {
                    Section(header: Text("Apple Health")) {
                        
                        Button(action: {
                            if let healthStore = model.healthStore {
                                if model.drinkData.lastHKSave == nil {
                                    healthStore.requestAuthorization { succcess in
                                        if succcess {
                                            healthStore.getHealthKitData { statsCollection in
                                                if let statsCollection = statsCollection {
                                                    model.retrieveFromHealthKit(statsCollection)
                                                    model.saveToHealthKit()
                                                    DispatchQueue.main.async {
                                                        model.drinkData.healthKitEnabled = true
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(DrinkModel(test: false, suiteName: nil))
    }
}
