//
//  OnboardingDailyGoalView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct OnboardingDailyGoalView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    
    var selectedUnit: String
    
    @State var dailyGoal = "2000"
    @State var isReccomendationsShowing = false
    
    @ScaledMetric(relativeTo: .body) var symbolSize = 75
    
    var body: some View {
        
        Form {
            // Symbol
            if #available(iOS 14, *) {
                Section {
                    // if iOS 15 show monochrome symbol with changed
                    // background and removed seperator
                    if #available(iOS 15, *) {
                        HStack {
                            
                            Spacer()
                            
                            Image(systemName: "flag")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: symbolSize, height: symbolSize)
                                .foregroundColor(model.grayscaleEnabled ? .primary : .blue)
                            
                            Spacer()
                        }
                        .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                        .listSectionSeparator(.hidden)
                    // if iOS 14 show monochrome symbol with no
                    // other changes
                    } else {
                        HStack {
                            
                            Spacer()
                            
                            Image(systemName: "flag")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: symbolSize, height: symbolSize)
                                .foregroundColor(model.grayscaleEnabled ? .primary : .blue)
                            
                            Spacer()
                        }
                    }
                }
            }
            
            // Instruction Text
            Section {
                // if iOS 15, remove seperators and changed background
                // color
                if #available(iOS 15, *) {
                    HStack {
                        
                        Spacer()
                        
                        Text("Now set your daily intake goal")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                    }
                    .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                    .listSectionSeparator(.hidden)
                // if iOS 14 or older, don't do the above
                } else {
                    HStack {
                        
                        Spacer()
                        
                        Text("Now set your daily intake goal")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                    }
                }
            }
            
            // Text Field
            Section {
                HStack {
                    
                    Spacer()
                    
                    // TextField
                    TextField("2000", text: $dailyGoal)
                        .keyboardType(.decimalPad)
                    
                    // Units
                    Text(self.getUnits(unitName: selectedUnit))
                    
                    Spacer()
                }
            }
            
            // Intake Recommendations
            Section {
                Button {
                    isReccomendationsShowing = true
                } label: {
                    if !sizeCategory.isAccessibilityCategory {
                        HStack {
                            
                            Spacer()
                            
                            Label("Daily Intake Recommendations", systemImage: "info.circle")
                            
                            Spacer()
                        }
                    } else {
                        VStack(alignment: .leading) {
                            Image(systemName: "info.circle")
                            Text("Daily Intake Recomendation")
                        }
                    }
                }
                // Display Recommendations when button is pressed
                .sheet(isPresented: $isReccomendationsShowing) {
                    // onDismiss set to false
                    isReccomendationsShowing = false
                } content: {
                    // Show DailyIntakeInfoView
                    DailyIntakeInfoView(color: colorScheme == .light ? Color(.systemGray6) : Color.black, units: self.getUnits(unitName: selectedUnit))
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    OnboardingDefaultDrinksView()
                } label: {
                    Text("Next")
                }
            }
        }
        .onDisappear {
            if let num = Double(dailyGoal) {
                model.drinkData.dailyGoal = num
                model.save()
            }
        }
    }
    
    // Get unit abbreviation
    func getUnits(unitName: String) -> String {
        if unitName == Constants.milliliters {
            return Constants.mL
        } else if unitName == Constants.liters {
            return Constants.L
        } else if unitName == Constants.fluidOuncesUS {
            return Constants.flOzUS
        } else if unitName == Constants.cupsUS {
            return Constants.cups
        }
        return ""
    }
}

struct OnboardingDailyGoalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingDailyGoalView(selectedUnit: Constants.milliliters)
            OnboardingDailyGoalView(selectedUnit: Constants.milliliters)
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }
}
