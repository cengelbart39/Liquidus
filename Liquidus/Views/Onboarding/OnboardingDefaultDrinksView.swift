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
        Form {
            if #available(iOS 14.0, *) {
                Section {
                    HStack {
                        
                        Spacer()
                        
                        if #available(iOS 15, *) {
                            Image("custom.drink-3.0")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                        } else {
                            Image("custom.drink-2.0")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                    }
                    .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                }
            }
            
            Section {
                HStack {
                    
                    Spacer ()
                    
                    Text("Liquidus comes with 4 default drink types. These can be enabled and disabled at any time.")
                        .font(.title2)
                    
                    Spacer()
                }
                .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
            }
            
            // Drink Toggles
            Section {
                List {
                    ForEach(model.drinkData.defaultDrinkTypes, id: \.self) { type in
                        OnboardingToggleDrinksView(type: type)
                    }
                }
            }
        }
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
