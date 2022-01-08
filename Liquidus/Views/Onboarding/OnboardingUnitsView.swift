//
//  OnboardingUnitsView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct OnboardingUnitsView: View {
    
    @EnvironmentObject var model: DrinkModel
    @Environment(\.colorScheme) var colorScheme
    
    @State var selectedUnit = Constants.milliliters
    
    @ScaledMetric(relativeTo: .body) var symbolSize = 75
    
    var body: some View {
        Form {
            if #available(iOS 14, *) {
                Section {
                    // if iOS 15...
                    if #available(iOS 15, *) {
                        HStack {
                            
                            Spacer()
                            
                            // Show hierarchical symbol
                            Image("custom.lines.measurement.horizontal-3.0")
                                .resizable()
                                .scaledToFit()
                                .frame(width: symbolSize, height: symbolSize)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(model.grayscaleEnabled ? .primary : .blue)
                            
                            Spacer()
                            
                        }
                        // Remove seperators and change background color
                        .listSectionSeparator(.hidden)
                        .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                    
                    // if iOS 14...
                    } else {
                        HStack {
                            
                            Spacer()
                            
                            // Show monochrome symbol
                            Image("custom.lines.measurement.horizontal-2.0")
                                .resizable()
                                .scaledToFit()
                                .frame(width: symbolSize, height: symbolSize)
                                .foregroundColor(model.grayscaleEnabled ? .primary : .blue)
                            
                            Spacer()
                            
                        }
                    }
                }
            }
            
            Section {
                // of iOS 15
                if #available(iOS 15.0, *) {
                    // Change background color and remove seperators
                    Text("First select which units you want to use")
                        .font(.title2)
                        .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                        .listSectionSeparator(.hidden)
                } else {
                    // Don't change background color and remove seperators
                    Text("First select which units you want to use")
                        .font(.title2)
                        .padding(.horizontal)
                }
            }
            
            
            // Unit Picker
            Section {
                if #available(iOS 14, *) {
                    // if iOS 15, use .inline picker style
                    if #available(iOS 15, *) {
                        Picker("Choose a Unit", selection: $selectedUnit) {
                            Text("\(Constants.cupsUS) (\(Constants.cups))")
                                .tag(Constants.cupsUS)
                            Text("\(Constants.fluidOuncesUS) (\(Constants.flOzUS))")
                                .tag(Constants.fluidOuncesUS)
                            Text("\(Constants.liters) (\(Constants.L))")
                                .tag(Constants.liters)
                            Text("\(Constants.milliliters) (\(Constants.mL))")
                                .tag(Constants.milliliters)
                        }
                        .pickerStyle(InlinePickerStyle())
                    } else {
                        // if older than iOS 15, use wheel picker style
                        Picker("Choose a Unit", selection: $selectedUnit) {
                            Text("\(Constants.cupsUS) (\(Constants.cups))")
                                .tag(Constants.cupsUS)
                            Text("\(Constants.fluidOuncesUS) (\(Constants.flOzUS))")
                                .tag(Constants.fluidOuncesUS)
                            Text("\(Constants.liters) (\(Constants.L))")
                                .tag(Constants.liters)
                            Text("\(Constants.milliliters) (\(Constants.mL))")
                                .tag(Constants.milliliters)
                        }
                        .pickerStyle(InlinePickerStyle())
                        .padding(.horizontal, -20)
                    }
                }
            }
        }
        .multilineTextAlignment(.center)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    OnboardingDailyGoalView(selectedUnit: selectedUnit)
                } label: {
                    Text("Next")
                }

            }
        }
        .onDisappear {
            // Update and save model
            model.drinkData.units = selectedUnit
            model.save()
        }
    }
}
    
    struct OnboardingUnitsView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                OnboardingUnitsView()
                    .environment(\.sizeCategory, .extraExtraExtraLarge)
                    .environmentObject(DrinkModel())
                OnboardingUnitsView()
                    .preferredColorScheme(.dark)
                    .environmentObject(DrinkModel())
            }
        }
    }
