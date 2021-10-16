//
//  OnboardingToggleDrinksView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct OnboardingToggleDrinksView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var type: String
    
    @State var isEnabled = true
    
    var body: some View {
        Toggle(type, isOn: $isEnabled)
            .onChange(of: isEnabled) { newValue in
                // When isEnabled changes update model
                model.drinkData.enabled[type]! = isEnabled
            }
    }
}

struct OnboardingToggleDrinksView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingToggleDrinksView(type: Constants.waterKey)
    }
}
