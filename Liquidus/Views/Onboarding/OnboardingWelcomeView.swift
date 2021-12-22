//
//  OnboardingWelcomeView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundColor(colorScheme == .light ? Color(.systemGray6) : .black)
                .ignoresSafeArea()
            
            VStack {
                
                Image("AppIcon-Transparent")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding(.bottom, -20)
                
                Text("Welcome to Liquidus!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)
                
                Text("Here you can take steps to staying hydrated while seeing what you drink and how much you drink.")
                    .font(.title3)
                    .padding(.bottom)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }

    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingWelcomeView()
            
    }
}
