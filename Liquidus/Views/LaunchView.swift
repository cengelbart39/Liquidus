//
//  LaunchView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct LaunchView: View {
        
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var model: DrinkModel
    
    var body: some View {
        
        // If the user is onboarding, show onboarding screens
        if model.userInfo.isOnboarding {
            OnboardingWelcomeView()
                .navigationBarHidden(true)
                .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.grayscaleStatusDidChangeNotification)) { _ in
                    model.grayscaleEnabled.toggle()
                }
                .onAppear {
                    model.grayscaleEnabled = UIAccessibility.isGrayscaleEnabled
                    
                    if !Calendar.current.isDate(model.userInfo.currentDay, inSameDayAs: Date()) {
                        
                        model.userInfo.currentDay = Date()
                        model.userInfo.dailyTotalToGoal = 0.0
                    }
                }
        // If the user isn't onboarding, start with TabBar
        } else if !model.userInfo.isOnboarding {
            TabBar()
                .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.grayscaleStatusDidChangeNotification)) { _ in
                    model.grayscaleEnabled.toggle()
                }
                .onAppear {
                    model.grayscaleEnabled = UIAccessibility.isGrayscaleEnabled
                    
                    if !Calendar.current.isDate(model.userInfo.currentDay, inSameDayAs: Date()) {
                        
                        model.userInfo.currentDay = Date()
                        model.userInfo.dailyTotalToGoal = 0.0
                    }
                }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
