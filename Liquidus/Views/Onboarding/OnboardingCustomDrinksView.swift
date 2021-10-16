//
//  OnboardingCustomDrinksView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct OnboardingCustomDrinksView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var isPresented = false
    
    var body: some View {
        
        Form {
            // MARK: - Instruction Text
            Section {
                Text("You can also add custom drink types that aren't built in by default.")
                    .font(.title2)
                    .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
            }
            Section {
                Text("You can always edit, delete, and add more later")
                    .font(.title3)
                    .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
            }
            
            // MARK: - Custom Drinks
            Section {
                CustomDrinkTypeDisplay()
            }
            
            Section {
                HStack {
                    
                    Spacer()
                    
                    Button {
                        // Update isPresented
                        isPresented = true
                    } label: {
                        Text("Add Drink Type")
                    }
                    // Show sheet
                    .sheet(isPresented: $isPresented) {
                        SettingsNewDrinkTypeView(isPresented: $isPresented)
                            .environmentObject(model)
                    }
                    
                    Spacer()
                }
            }
        }
        .multilineTextAlignment(.center)
    }
}

struct OnboardingCustomDrinksView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCustomDrinksView()
            .environmentObject(DrinkModel())
    }
}
