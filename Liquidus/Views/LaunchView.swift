//
//  LaunchView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @State var isOnboarding = true
    
    var body: some View {
        
        // If the user is onboarding, show onboarding screens
        if model.drinkData.isOnboarding && isOnboarding {
            OnboardingMainView(isOnboarding: $isOnboarding)
                .navigationBarHidden(true)
        // If the user isn't onboarding, start with TabBar
        } else if !model.drinkData.isOnboarding || !isOnboarding {
            TabBar()
        }
        
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
