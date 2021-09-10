//
//  DailyGoalSettings.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct DailyGoalSettings: View {
    
    @EnvironmentObject var model: DrinkModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var dailyGoal = ""
    
    var body: some View {
        
        Form {
            
            Section() {
                
                HStack {
                    // Daily Goal input
                    TextField("\(model.drinkData.dailyGoal, specifier: "%.0f")", text: $dailyGoal)
                        .keyboardType(.numberPad)
                    
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
            
        }
        .padding(.top, -10)
        .navigationBarTitle("Daily Goal Settings")
    }
}
