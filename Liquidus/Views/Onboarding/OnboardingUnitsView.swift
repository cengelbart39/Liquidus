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
                    HStack {
                
                        Spacer ()
                        
                        if #available(iOS 15, *) {
                            Image("custom.lines.measurement.horizontal-3.0")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                        } else {
                            Image("custom.lines.measurement.horizontal-2.0")
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
                Text("First select which units you want to use")
                    .font(.title2)
                    .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
            }
            
            // Unit Picker
            Section {
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
