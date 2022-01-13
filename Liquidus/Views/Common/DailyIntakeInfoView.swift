//
//  DailyIntakeInfoView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct DailyIntakeInfoView: View {
    
    @EnvironmentObject var model: DrinkModel
    @Environment(\.presentationMode) var presentationMode
    
    var color: Color
    
    var units: String? = nil
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Rectangle()
                    .foregroundColor(color)
                    .ignoresSafeArea()
                
                // Male Recommendations per Unit
                let maleRecommendations = [
                    Constants.cups : 15.5,
                    Constants.flOzUS : 124,
                    Constants.L : 3.7,
                    Constants.mL : 3700
                ]
                
                // Female Recommendations per Unit
                let femaleRecommendations = [
                    Constants.cups : 11.5,
                    Constants.flOzUS : 92,
                    Constants.L : 2.7,
                    Constants.mL : 2700
                ]
                
                ScrollView {
                    VStack {
                        VStack(alignment: .leading) {

                            
                            // Background Text
                            Text("The United States National Academies of Sciences, Engineering, and Medicine determined that an adequate daily fluid intake is (based on biological gender):")
                                .padding(.bottom, 10)
                            
                            // Male Recommendations
                            let maleAmount = maleRecommendations[units != nil ? units! : model.getUnits()]!
                            
                            Label("\(maleAmount, specifier: model.getSpecifier(amount: maleAmount)) \(units != nil ? units! : model.getUnits()) for Men", systemImage: "circle.fill")
                                .padding(.bottom, 10)
                            
                            // Female Recommendations
                            let femaleAmount = femaleRecommendations[units != nil ? units! : model.getUnits()]!
                            
                            Label("\(femaleAmount, specifier: model.getSpecifier(amount: femaleAmount)) \(units != nil ? units! : model.getUnits()) for Women", systemImage: "circle.fill")
                                .padding(.bottom)
                            
                            // Source
                            Text("Sourced from the Mayo Clinic")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.top)
                        .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                    .multilineTextAlignment(.leading)
                }
            }
            .navigationTitle("Recommendations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Show "Back" button
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Back")
                    }
                }
            }
            .accessibilityAction(named: "Back") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct DailyIntakeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DailyIntakeInfoView(color: Color(.systemGray6))
            .environmentObject(DrinkModel())
    }
}
