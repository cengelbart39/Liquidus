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
                        if tabSelection == 0 {
                            tabSelection = 1
                        } else if tabSelection == 1 {
                            model.drinkData.units = selectedUnit
                            tabSelection = 2
                        } else if tabSelection == 2 {
                            if let num = Double(dailyGoal) {
                                model.drinkData.dailyGoal = num
                                model.save()
                            }
                            tabSelection = 3
                        } else if tabSelection == 3 {
                            model.save()
                            tabSelection = 4
                        } else if tabSelection == 4 {
                            tabSelection = 5
                        } else if tabSelection == 5 {
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
                        
                        if tabSelection >= 0 && tabSelection <= 4 {
                            withAnimation {
                                Text("Continue")
                                    .foregroundColor(.blue)
                            }
                        } else if !healthKitEnabled && tabSelection == 5 {
                            withAnimation {
                                Text("Skip")
                                    .foregroundColor(.blue)
                            }
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
