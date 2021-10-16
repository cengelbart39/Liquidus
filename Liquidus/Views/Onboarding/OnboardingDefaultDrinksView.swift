//
//  OnboardingDefaultDrinksView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct OnboardingDefaultDrinksView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var model: DrinkModel
    
    @State var isEnabled = true
    
    var body: some View {
        
        VStack {
            Text("Liquidus comes with 4 default drink types. These can be enabled and disabled at any time.")
                .font(.title2)
                .padding(.bottom)
            
            Form {
                List {
                    ForEach(model.drinkData.defaultDrinkTypes, id: \.self) { type in
                        OnboardingToggleDrinksView(type: type)
                    }
                }
            }
            .frame(height: 250)
        }
        .padding(.horizontal)
        .multilineTextAlignment(.center)
        .navigationBarHidden(true)
    }
}

struct OnboardingDefaultDrinksView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingDefaultDrinksView()
            .environmentObject(DrinkModel())
    }
}
