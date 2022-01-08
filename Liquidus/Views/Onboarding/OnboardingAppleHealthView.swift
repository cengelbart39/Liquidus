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
    
    @State var healthKitEnabled = false
        
    @ScaledMetric(relativeTo: .body) var imageSize = 75
    
    var body: some View {
        
        Form {
            // Section Image
            if #available(iOS 14, *) {
                Section {
                    // if iOS 15, show hierarchical symbol, change
                    // background color, and remove symbols
                    if #available(iOS 15, *) {
                            
                        HStack {
                            Spacer ()
                            
                            Image(systemName: "heart.text.square")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: imageSize, height: imageSize)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(model.grayscaleEnabled ? .primary : .blue)
                            
                            Spacer()
                        }
                        .listRowBackground(colorScheme == .light ? Color(.systemGray6) : Color.black)
                        .listSectionSeparator(.hidden)
                    // if iOS 14, only show monochrome symbol
                    } else {
                        HStack {
                            Spacer ()
                            
                            Image(systemName: "heart.text.square")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: imageSize, height: imageSize)
                                .foregroundColor(model.grayscaleEnabled ? .primary : .blue)
                            
                            Spacer()
                        }
                    }
                }
            }
            
            // Instructions
            Section {
                // if iOS 15, change background color and remove
                // seperators
                if #available(iOS 15.0, *) {
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
                    .listSectionSeparator(.hidden)
                    
                // if not, don't do the above
                } else {
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
                }
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Update and save onboarding status
                    model.drinkData.isOnboarding = false
                    model.save()
                } label: {
                    if healthKitEnabled {
                        Text("Done")
                    } else {
                        Text("Skip")
                    }
                }
            }
        }
    }
}

struct OnboardingAppleHealthView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingAppleHealthView()
                .environmentObject(DrinkModel())
            OnboardingAppleHealthView()
                .preferredColorScheme(.dark)
                .environmentObject(DrinkModel())
        }
    }
}
