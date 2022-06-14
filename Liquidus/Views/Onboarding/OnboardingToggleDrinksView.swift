//
//  OnboardingToggleDrinksView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct OnboardingToggleDrinksView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var type: DrinkType
    
    @State var isEnabled = true
    
    var body: some View {
        Toggle(type.name, isOn: $isEnabled)
            .onChange(of: isEnabled) { newValue in
                // When isEnabled changes update model
                type.enabled = newValue
            }
    }
}
