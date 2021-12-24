//
//  OnboardingUnitsView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct OnboardingUnitsView: View {
    
    @EnvironmentObject var model: DrinkModel
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var selectedUnit: String
    
    var body: some View {
        Form {
            if #available(iOS 14, *) {
                Section {
                    if #available(iOS 15, *) {
                        HStack {
                            
                            Spacer()
                            
                            Image("custom.lines.measurement.horizontal-3.0")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                        }
                        .listSectionSeparator(.hidden)
                        .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                        
                    } else {
                        HStack {
                            
                            Spacer()
                            
                            Image("custom.lines.measurement.horizontal-2.0")
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
                if #available(iOS 15.0, *) {
                    Text("First select which units you want to use")
                        .font(.title2)
                        .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                        .listSectionSeparator(.hidden)
                } else {
                    Text("First select which units you want to use")
                        .font(.title2)
                    //.listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .listRowInsets(EdgeInsets())
                        .padding(.horizontal)
                }
            }
            
            
            // Unit Picker
            Section {
                if #available(iOS 14, *) {
                    if #available(iOS 15, *) {
                        Picker("Choose a Unit", selection: $selectedUnit) {
                            Text("\(Constants.cupsUS) (\(Constants.cups))")
                                .tag(Constants.cupsUS)
                            Text("\(Constants.fluidOuncesUS) (\(Constants.flOzUS))")
                                .tag(Constants.fluidOuncesUS)
                            Text("\(Constants.liters) (\(Constants.L))")
                                .tag(Constants.liters)
                            Text("\(Constants.milliliters) (\(Constants.mL))")
                                .tag(Constants.milliliters)
                        }
                        .pickerStyle(InlinePickerStyle())
                    } else {
                        Picker("Choose a Unit", selection: $selectedUnit) {
                            Text("\(Constants.cupsUS) (\(Constants.cups))")
                                .tag(Constants.cupsUS)
                            Text("\(Constants.fluidOuncesUS) (\(Constants.flOzUS))")
                                .tag(Constants.fluidOuncesUS)
                            Text("\(Constants.liters) (\(Constants.L))")
                                .tag(Constants.liters)
                            Text("\(Constants.milliliters) (\(Constants.mL))")
                                .tag(Constants.milliliters)
                        }
                        .pickerStyle(InlinePickerStyle())
                        .padding(.horizontal, -20)
                    }
                }
            }
        }
        .multilineTextAlignment(.center)
        .navigationBarHidden(true)
    }
}
    
    struct OnboardingUnitsView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                OnboardingUnitsView(selectedUnit: .constant(Constants.milliliters))
                    .environmentObject(DrinkModel())
                OnboardingUnitsView(selectedUnit: .constant(Constants.milliliters))
                    .preferredColorScheme(.dark)
                    .environmentObject(DrinkModel())
            }
        }
    }
