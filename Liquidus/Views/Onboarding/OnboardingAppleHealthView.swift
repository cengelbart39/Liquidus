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
        
        VStack {
            // Section Image
            if #available(iOS 14, *) {
                if #available(iOS 15, *) {
                    Image(systemName: "heart.text.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.blue)
                        .padding(.bottom)
                        .padding(.top, -95)
                } else {
                    Image(systemName: "heart.text.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                        .foregroundColor(.blue)
                        .padding(.bottom)
                        .padding(.top, -95)
                }
            }
            
            // Instructions
            Text("Liquidus can read and write water consumption data from Apple Health.")
                .font(.title2)
                .padding(.bottom)
            
            Text("You can always enable this later in the app's Settings.")
                .font(.title3)
                .padding(.bottom)
            
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
                                    }
                                }
                            }
                        }
                    }
                }
            }, label: {
                ZStack {
                    RectangleCard(color: colorScheme == .light ? .white : Color(.systemGray6))
                        .frame(width: 200, height: 45)
                        .shadow(radius: 5)
                    
                    Text("Sync with Apple Health")
                        .foregroundColor(Color(.systemPink))
                }
            })
                .padding(.bottom)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal)
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
