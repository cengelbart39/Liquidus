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
    
    @Binding var dailyGoal: String
    var selectedUnit: String
    
    @State var isReccomendationsShowing = false
    
    var body: some View {
        
        
        VStack {
            
            Text("Now set your daily intake goal")
                .font(.title2)
                .padding(.bottom)
            
            HStack {
                
                Spacer()
                
                TextField("2000", text: $dailyGoal)
                    .frame(width: 75)
                    .keyboardType(.decimalPad)
                
                Text(self.getUnits(unitName: selectedUnit))
                
                Spacer()
            }
            .padding(.bottom)
            
            Button {
                isReccomendationsShowing = true
            } label: {
                Label("Daily Intake Recommendations", systemImage: "info.circle")
            }
            .sheet(isPresented: $isReccomendationsShowing) {
                isReccomendationsShowing = false
            } content: {
                DailyIntakeInfoView(color: colorScheme == .light ? Color(.systemGray6) : Color.black)
            }
            .padding(.bottom)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .navigationBarHidden(true)
    }
    
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
        OnboardingDailyGoalView(dailyGoal: .constant("2000"), selectedUnit: Constants.milliliters)
            .environmentObject(DrinkModel())
    }
}
