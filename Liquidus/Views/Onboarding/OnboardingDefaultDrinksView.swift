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
                    // if iOS 15, show heirarchical symbol
                    // remove seperators, and change background
                    // color
                    if #available(iOS 15, *) {
                        HStack {
                            Spacer ()
                            
                            Image("custom.drink-3.0")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                            
                            Spacer ()
                            
                        }
                        .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                        .listSectionSeparator(.hidden)
                    // if iOS 14, show monochrome symbol with none
                    // of the other changes
                    } else {
                        HStack {
                            Spacer()
                            
                            Image("custom.drink-2.0")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                                .foregroundColor(.blue)

                            Spacer()
                        }
                    }
                    
                }
            }
            
            Section {
                // if iOS 15, remove seperators and change background
                // color
                if #available(iOS 15, *) {
                    HStack {
                        
                        Spacer ()
                        
                        Text("Liquidus comes with 4 default drink types. These can be enabled and disabled at any time.")
                            .font(.title2)
                        
                        Spacer()
                    }
                    .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                    .listSectionSeparator(.hidden)
                // if older, don't do the above
                } else {
                    HStack {
                        
                        Spacer ()
                        
                        Text("Liquidus comes with 4 default drink types. These can be enabled and disabled at any time.")
                            .font(.title2)
                        
                        Spacer()
                    }
                }
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
