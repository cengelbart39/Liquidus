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
                    TextField("\(model.drinkData.dailyGoal, specifier: "%.0f")", text: $dailyGoal)
                        .keyboardType(.numberPad)
                    
                    Button(action: {
                        if let num = Double(dailyGoal) {
                            model.drinkData.dailyGoal = num
                            model.save()
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
