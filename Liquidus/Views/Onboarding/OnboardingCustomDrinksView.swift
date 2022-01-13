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
    
    @ScaledMetric(relativeTo: .body) var imageSize = 75
    
    var body: some View {
        
        Form {
            // MARK: - Section Image
            Section {
                HStack {
                    Spacer()
                    
                    Image("custom.drink.badge.plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize, height: imageSize)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(model.grayscaleEnabled ? .primary : .blue)
                    
                    Spacer()
                }
                .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                .listSectionSeparator(.hidden)
                .accessibilityHidden(true)
            }
            
            
            // MARK: - Instruction Text
            Section {
                Text("You can also add custom drink types that aren't built in by default.")
                    .font(.title2)
                    .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                    .listSectionSeparator(.hidden)
            }
            Section {
                Text("You can always edit, delete, and add more later")
                    .font(.title3)
                    .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                    .listSectionSeparator(.hidden)
            }
            
            // MARK: - Custom Drinks
            Section {
                CustomDrinkTypeView()
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
                        NewDrinkTypeView(isPresented: $isPresented)
                            .environmentObject(model)
                    }
                    
                    Spacer()
                }
            }
        }
        .multilineTextAlignment(.center)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    OnboardingAppleHealthView()
                } label: {
                    Text("Next")
                }
            }
        }
    }
}

struct OnboardingCustomDrinksView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingCustomDrinksView()
                .environmentObject(DrinkModel())
            OnboardingCustomDrinksView()
                .preferredColorScheme(.dark)
                .environmentObject(DrinkModel())
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        }
    }
}
