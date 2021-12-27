//
//  OnboardingDailyGoalView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct OnboardingDailyGoalView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var dailyGoal: String
    var selectedUnit: String
    
    @State var isReccomendationsShowing = false
    
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
                                .frame(width: 75, height: 75)
                                .foregroundColor(.blue)
                            
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
                                .frame(width: 75, height: 75)
                                .foregroundColor(.blue)
                            
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
                        .frame(width: 70)
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
                    HStack {
                        
                        Spacer()
                        
                        Label("Daily Intake Recommendations", systemImage: "info.circle")
                        
                        Spacer()
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
        .navigationBarHidden(true)
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
            OnboardingDailyGoalView(dailyGoal: .constant("2000"), selectedUnit: Constants.milliliters)
            OnboardingDailyGoalView(dailyGoal: .constant("2000"), selectedUnit: Constants.milliliters)
                .preferredColorScheme(.dark)
        }
    }
}
