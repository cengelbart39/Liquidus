//
//  DailyIntakeInfoView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct DailyIntakeInfoView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var color: Color
    
    var units: String? = nil
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea()
            
            // Male Recommendations per Unit
            let maleRecommendations = [
                Constants.cupsUS : 15.5,
                Constants.fluidOuncesUS : 124,
                Constants.liters : 3.7,
                Constants.milliliters : 3700
            ]
            
            // Female Recommendations per Unit
            let femaleRecommendations = [
                Constants.cupsUS:11.5,
                Constants.fluidOuncesUS:92,
                Constants.liters:2.7,
                Constants.milliliters:2700
            ]
            
            VStack {
                VStack(alignment: .leading) {
                    // Background Text
                    Text("The United States National Academies of Sciences, Engineering, and Medicine determined that an adequate daily fluid intake is (based on biological gender):")
                        .padding(.bottom, 10)
                    
                    // Male Recommendations
                    let maleAmount = maleRecommendations[units != nil ? units! : model.drinkData.units]!
                    
                    Label("\(maleAmount, specifier: model.getSpecifier(amount: maleAmount)) \(units != nil ? model.onboardingGetUnits(name: units!) : model.getUnits()) for Men", systemImage: "circle.fill")
                        .padding(.bottom, 10)
                    
                    // Female Recommendations
                    let femaleAmount = femaleRecommendations[units != nil ? units! : model.drinkData.units]!
                    
                    Label("\(femaleAmount, specifier: model.getSpecifier(amount: femaleAmount)) \(units != nil ? model.onboardingGetUnits(name: units!) : model.getUnits()) for Women", systemImage: "circle.fill")
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
}

struct DailyIntakeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DailyIntakeInfoView(color: Color(.systemGray6))
    }
}
