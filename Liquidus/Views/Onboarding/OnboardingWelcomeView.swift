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
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    
                    Rectangle()
                        .foregroundColor(colorScheme == .light ? Color(.systemGray6) : .black)
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack {
                            
                            Spacer()
                            
                            // Image
                            Image("AppIcon-Transparent")
                                .resizable()
                                .scaledToFit()
                                .padding(.all, -20)
                                .frame(width: geo.size.width, height: geo.size.height/2.2)
                            
                            // Welcome Text
                            Text("Welcome to Liquidus!")
                                .font(.largeTitle)
                                .bold()
                                .padding([.bottom, .horizontal])
                            
                            // Description Text
                            Text("Here you can take steps to staying hydrated while seeing what you drink and how much you drink.")
                                .font(.title3)
                                .padding([.bottom, .horizontal])
                            
                            Spacer()
                        }
                        .multilineTextAlignment(.center)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        OnboardingUnitsView()
                    } label: {
                        Text("Next")
                    }
                }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingWelcomeView()
            
    }
}
