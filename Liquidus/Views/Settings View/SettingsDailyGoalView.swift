//
//  SettingsDailyGoalView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//
//  Keyboard Dismiss Code by pawello2222 on StackOverflow
//  https://stackoverflow.com/a/63942065
//

import SwiftUI
import WidgetKit

struct SettingsDailyGoalView: View {
    
    @EnvironmentObject var model: DrinkModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State var dailyGoal = ""
    @State var reccomendationsShowing = false
        
    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        
        Form {
            
            Section(footer: Text("Weekly goal adjusts accordingly")) {
                
                HStack {
                    // Daily Goal input
                    TextField("\(Int(model.userInfo.dailyGoal))", text: $dailyGoal)
                        .keyboardType(.decimalPad)
                        .focused($isFieldFocused)
                    
                    Spacer()
                    
                    Text(model.getUnits())
                }
                .accessibilityElement(children: .combine)
                .accessibilityValue("\(model.userInfo.dailyGoal, specifier: model.getSpecifier(amount: model.userInfo.dailyGoal)) \(model.getAccessibilityUnitLabel())")
                .accessibilityHint("Edit text to change your goal")
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
        .navigationBarTitle("Daily Goal")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Save button
                Button(action: {
                    if let num = Double(dailyGoal) {
                        // Update daily goal
                        model.userInfo.dailyGoal = num
                        // Save to user defaults
                        model.saveUserInfo(test: false)
                        // Update Widget
                        WidgetCenter.shared.reloadAllTimelines()
                        // Dismiss screen
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Save")
                })
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
        .accessibilityAction(named: "Save") {
            if let num = Double(dailyGoal) {
                // Update daily goal
                model.userInfo.dailyGoal = num
                // Save to user defaults
                model.saveUserInfo(test: false)
                // Dismiss screen
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct SettingsDailyGoalView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsDailyGoalView()
            .environmentObject(DrinkModel(test: false, suiteName: nil))
    }
}
