//
//  LaunchView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var body: some View {
        
        // If the user is onboarding, show onboarding screens
        if model.drinkData.isOnboarding {
            OnboardingWelcomeView()
                .navigationBarHidden(true)
                .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.grayscaleStatusDidChangeNotification)) { _ in
                    model.grayscaleEnabled.toggle()
                }
                .onAppear {
                    model.grayscaleEnabled = UIAccessibility.isGrayscaleEnabled
                }
        // If the user isn't onboarding, start with TabBar
        } else if !model.drinkData.isOnboarding {
            TabBar()
                .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.grayscaleStatusDidChangeNotification)) { _ in
                    model.grayscaleEnabled.toggle()
                }
                .onAppear {
                    model.grayscaleEnabled = UIAccessibility.isGrayscaleEnabled
                }
        }
        
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
