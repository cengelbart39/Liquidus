//
//  OnboardingAppleHealthView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI
import HealthKit

struct OnboardingAppleHealthView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var healthKitEnabled : Bool
    
    var body: some View {
        
        Form {
            // Section Image
            if #available(iOS 14, *) {
                Section {
                    HStack {
                        
                        Spacer()
                        
                        if #available(iOS 15, *) {
                            Image(systemName: "heart.text.square")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "heart.text.square")
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
            
            // Instructions
            Section {
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        Text("Liquidus can read and write water consumption data from Apple Health.\n")
                            .font(.title2)
                    
                        Text("You can always enable this later in the app's Settings.")
                            .font(.title3)
                    }
                    
                    Spacer()
                }
                .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
            }
            
            // Ask for Apple Health access and pull data if authorized
            Button(action: {
                if let healthStore = model.healthStore {
                    if model.drinkData.lastHKSave == nil {
                        healthStore.requestAuthorization { succcess in
                            if succcess {
                                healthKitEnabled = true
                                healthStore.getHealthKitData { statsCollection in
                                    if let statsCollection = statsCollection {
                                        model.retrieveFromHealthKit(statsCollection)
                                        model.saveToHealthKit()
                                        DispatchQueue.main.async {
                                            model.drinkData.healthKitEnabled = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }, label: {
                HStack {
                    
                    Spacer()
                    
                    Text("Sync with Apple Health")
                        .foregroundColor(.pink)
                    
                    Spacer()
                }
            })
        }
        .multilineTextAlignment(.center)
        .navigationBarHidden(true)
    }
}

struct OnboardingAppleHealthView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingAppleHealthView(healthKitEnabled: .constant(true))
                .environmentObject(DrinkModel())
            OnboardingAppleHealthView(healthKitEnabled: .constant(true))
                .preferredColorScheme(.dark)
                .environmentObject(DrinkModel())
        }
    }
}
