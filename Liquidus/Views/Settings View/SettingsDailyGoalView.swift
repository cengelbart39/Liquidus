//
//  SettingsDailyGoalView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct SettingsDailyGoalView: View {
    
    @EnvironmentObject var model: DrinkModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State var dailyGoal = ""
    @State var reccomendationsShowing = false
    
    var body: some View {
        
        Form {
            
            Section() {
                
                HStack {
                    // Daily Goal input
                    TextField("\(Int(model.drinkData.dailyGoal)) \(model.getUnits())", text: $dailyGoal)
                        .keyboardType(.decimalPad)
                    
                    // Save button
                    Button(action: {
                        if let num = Double(dailyGoal) {
                            // Update daily goal
                            model.drinkData.dailyGoal = num
                            // Save to user defaults
                            model.save()
                            // Dismiss screen
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Save")
                    })
                }
            }
            
            // Daily Intake Recommendations
            Section {
                Button {
                    reccomendationsShowing = true
                } label: {
                    Label("Daily Intake Recommendations", systemImage: "info.circle")
                }
                .sheet(isPresented: $reccomendationsShowing) {
                    reccomendationsShowing = false
                } content: {
                    DailyIntakeInfoView(color: colorScheme == .light ? Color(.systemGray6) : Color.black)
                }
            }
            
        }
        .padding(.top, -10)
        .navigationBarTitle("Daily Goal Settings")
    }
}
