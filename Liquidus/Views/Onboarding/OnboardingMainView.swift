//
//  OnboardingMainView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/12/21.
//

import SwiftUI
import HealthKit

struct OnboardingMainView: View {
    
    @EnvironmentObject var model: DrinkModel
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isOnboarding: Bool
    
    @State var tabSelection = 0
    
    @State var healthKitEnabled = false
    
    @State var selectedUnit = Constants.milliliters
    @State var dailyGoal = "2000"
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(colorScheme == .light ? Color(.systemGray6) : .black)
                .ignoresSafeArea()
            
            VStack {
                // TabView
                TabView(selection: $tabSelection) {
                    OnboardingWelcomeView()
                        .tag(0)
                    OnboardingUnitsView(selectedUnit: $selectedUnit)
                        .tag(1)
                    OnboardingDailyGoalView(dailyGoal: $dailyGoal, selectedUnit: selectedUnit)
                        .tag(2)
                    OnboardingDefaultDrinksView()
                        .tag(3)
                    OnboardingCustomDrinksView()
                        .tag(4)
                    OnboardingAppleHealthView(healthKitEnabled: $healthKitEnabled)
                        .tag(5)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Button {
                    withAnimation {
                        // If on WelcomeView show UnitsView
                        if tabSelection == 0 {
                            tabSelection = 1
                        // If one UnitsView...
                        } else if tabSelection == 1 {
                            // Update and save model
                            model.drinkData.units = selectedUnit
                            model.save()
                            // Show DailyGoalView
                            tabSelection = 2
                        // If on DailyGoalView...
                        } else if tabSelection == 2 {
                            // Update and save model
                            if let num = Double(dailyGoal) {
                                model.drinkData.dailyGoal = num
                                model.save()
                            }
                            // Show DefaultDrinksView
                            tabSelection = 3
                        // If on DefaultDrinksView...
                        } else if tabSelection == 3 {
                            // Save changes
                            model.save()
                            // Show CustomDrinksView
                            tabSelection = 4
                        // If on CustomDrinksView...
                        } else if tabSelection == 4 {
                            // Show AppleHealthView
                            tabSelection = 5
                        // If on AppleHealthView
                        } else if tabSelection == 5 {
                            // Update and save onboarding status
                            model.drinkData.isOnboarding = false
                            model.save()
                            isOnboarding = false
                        }
                    }
                } label: {
                    ZStack {
                        RectangleCard(color: colorScheme == .light ? .white : Color(.systemGray6))
                            .frame(width: 200, height: 45)
                            .shadow(radius: 5)
                        
                        // If on Welcome, Units, DailyGoal, or Drink Type Views
                        // display "Continue"
                        if tabSelection >= 0 && tabSelection <= 4 {
                            withAnimation {
                                Text("Continue")
                                    .foregroundColor(.blue)
                            }
                        // If Health data access is not authorized
                        // and on AppleHealthView display "Skip"
                        } else if !healthKitEnabled && tabSelection == 5 {
                            withAnimation {
                                Text("Skip")
                                    .foregroundColor(.blue)
                            }
                        // If Health access authorized and on AppleHealthView
                        // display "Continue"
                        } else if tabSelection == 5 && healthKitEnabled {
                            withAnimation {
                                Text("Continue")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .padding(.bottom)
            }
        }
    }
}

struct OnboardingMainView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingMainView(isOnboarding: .constant(true))
            .environmentObject(DrinkModel())
    }
}
