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
        
        // Instructions
        VStack {
            if #available(iOS 14.0, *) {
                
                if #available(iOS 15, *) {
                    Image("custom.drink-3.0")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.blue)
                        .padding(.bottom)
                        .padding(.top, -95)
                } else {
                    Image("custom.drink-2.0")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                        .foregroundColor(.blue)
                        .padding(.bottom)
                        .padding(.top, -90)
                }
            }
            
            Text("Liquidus comes with 4 default drink types. These can be enabled and disabled at any time.")
                .font(.title2)
                .padding(.bottom)
            
            // Drink Toggles
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
        Group {
            OnboardingDefaultDrinksView()
                .environmentObject(DrinkModel())
            OnboardingDefaultDrinksView()
                .preferredColorScheme(.dark)
                .environmentObject(DrinkModel())
        }
    }
}
