//
//  OnboardingUnitsView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct OnboardingUnitsView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var drinkTypes: FetchedResults<DrinkType>
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var selectedUnit = Constants.milliliters
    
    @ScaledMetric(relativeTo: .body) var symbolSize = 75
    
    var body: some View {
        Form {
            Section {
                HStack {
                    
                    Spacer()
                    
                    // Show hierarchical symbol
                    Image("custom.lines.measurement.horizontal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: symbolSize, height: symbolSize)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(model.grayscaleEnabled ? .primary : .blue)
                        .accessibilityHidden(true)
                    
                    Spacer()
                    
                }
                // Remove seperators and change background color
                .listSectionSeparator(.hidden)
                .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
            }
            
            Section {
                Text("First select which units you want to use")
                    .font(.title2)
                    .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                    .listSectionSeparator(.hidden)
            }
            
            
            // Unit Picker
            Section {
                Picker("Choose a Unit", selection: $selectedUnit) {
                    Text("\(Constants.cupsUS) (\(Constants.cups))")
                        .tag(Constants.cupsUS)
                        .accessibilityLabel(Constants.cupsUS)
                    
                    Text("\(Constants.fluidOuncesUS) (\(Constants.flOzUS))")
                        .tag(Constants.fluidOuncesUS)
                        .accessibilityLabel(Constants.fluidOuncesUS)
                    
                    Text("\(Constants.liters) (\(Constants.L))")
                        .tag(Constants.liters)
                        .accessibilityLabel(Constants.liters)
                    
                    Text("\(Constants.milliliters) (\(Constants.mL))")
                        .tag(Constants.milliliters)
                        .accessibilityLabel(Constants.milliliters)
                }
                .pickerStyle(InlinePickerStyle())
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
            model.userInfo.units = selectedUnit
            model.saveUserInfo(test: false)
        }
    }
}

struct OnboardingUnitsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingUnitsView()
                .environment(\.sizeCategory, .extraExtraExtraLarge)
                .environmentObject(DrinkModel(test: false, suiteName: nil))
            OnboardingUnitsView()
                .preferredColorScheme(.dark)
                .environmentObject(DrinkModel(test: false, suiteName: nil))
        }
    }
}
