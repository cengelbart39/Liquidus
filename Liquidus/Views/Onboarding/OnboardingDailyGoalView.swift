//
//  OnboardingDailyGoalView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//
//  Keyboard Dismiss Code by pawello2222 on StackOverflow
//  https://stackoverflow.com/a/63942065
//

import SwiftUI

struct OnboardingDailyGoalView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicType
    
    var selectedUnit: String
    
    @State var dailyGoal = "2000"
    @State var isReccomendationsShowing = false
    
    @FocusState private var isFieldFocused: Bool
    
    @ScaledMetric(relativeTo: .body) var symbolSize = 75
    
    var body: some View {
        
        Form {
            Section {
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
                .accessibilityHidden(true)
            }
            
            // Instruction Text
            Section {
                HStack {
                    
                    Spacer()
                    
                    Text("Now set your daily intake goal")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                }
                .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                .listSectionSeparator(.hidden)
            }
            
            // Text Field
            Section {
                HStack {
                    // TextField
                    TextField("Amount", text: $dailyGoal)
                        .focused($isFieldFocused)
                        .keyboardType(.decimalPad)
                    
                    Spacer()
                    
                    // Units
                    Text(self.getUnits(unitName: selectedUnit))
                }
                .accessibilityElement(children: .combine)
                .accessibilityValue("\(dailyGoal) \(selectedUnit)")
                .accessibilityHint("Edit text to choose your goal")
            }
            
            // Intake Recommendations
            Section {
                Button {
                    isReccomendationsShowing = true
                } label: {
                    if !dynamicType.isAccessibilitySize {
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
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    
                    Button {
                        isFieldFocused = false
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
        .onDisappear {
            if let num = Double(dailyGoal) {
                model.drinkData.dailyGoal = num
                model.save(test: false)
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
