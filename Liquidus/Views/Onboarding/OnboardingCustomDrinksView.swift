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
            // MARK: - Section Image
            Section {
                if #available(iOS 14, *) {
                    // if iOS 15, show hierarchical symbol, change
                    // background color, and remove seperators
                    if #available(iOS 15, *) {
                        HStack {
                            Spacer()
                            
                            Image("custom.drink.badge.plus-3.0")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                            
                            Spacer()
                        }
                        .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                        .listSectionSeparator(.hidden)
                    
                    // if iOS 14, show monochrome symbol and do none
                    // of the above changes
                    } else {
                        HStack {
                            
                            Spacer()
                            
                            Image("custom.drink.badge.plus-2.0")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                                .foregroundColor(.blue)
                            
                            Spacer()
                        }
                    }
                    
                }
            }
            
            // MARK: - Instruction Text
            Section {
                // if iOS 15, remove seperators and change background
                // color
                if #available(iOS 15.0, *) {
                    Text("You can also add custom drink types that aren't built in by default.")
                        .font(.title2)
                        .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                        .listSectionSeparator(.hidden)
                // if not, don't do the above
                } else {
                    Text("You can also add custom drink types that aren't built in by default.")
                        .font(.title2)
                }
            }
            Section {
                // if iOS 15, remove seperators and change background
                // color
                if #available(iOS 15.0, *) {
                    Text("You can always edit, delete, and add more later")
                        .font(.title3)
                        .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                        .listSectionSeparator(.hidden)
                // if not, don't do the above
                } else {
                    Text("You can always edit, delete, and add more later")
                        .font(.title3)
                }
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
                        NewDrinkTypeView(isPresented: $isPresented)
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
        Group {
            OnboardingCustomDrinksView()
                .environmentObject(DrinkModel())
            OnboardingCustomDrinksView()
                .preferredColorScheme(.dark)
                .environmentObject(DrinkModel())
        }
    }
}
