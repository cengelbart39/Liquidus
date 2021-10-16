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
        
        if model.drinkData.isOnboarding && isOnboarding {
            OnboardingMainView(isOnboarding: $isOnboarding)
                .navigationBarHidden(true)
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
