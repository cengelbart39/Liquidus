//
//  TrendsDetailInfoView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 3/2/22.
//

import SwiftUI

struct TrendsDetailInfoView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var dataItems: [DataItem]
    var amount: Double
    var amountTypeText: String
    var amountText: Double
    var timeRangeText: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            // MARK: Amount Type Text
            Text(amountTypeText)
                .font(.body)
                .foregroundColor(.gray)
                .padding(.leading)
                .dynamicTypeSize(.xSmall ... .xxxLarge)
                                
            // MARK: Amount Text
            Group {
                Text("\(amountText, specifier: model.getSpecifier(amount: amount)) ")
                    .font(.title)
                    + Text(model.getUnits())
                        .font(.title3)
                        .bold()
                        .foregroundColor(.gray)
            }
            .dynamicTypeSize(.xSmall ... .xxxLarge)
            .padding(.leading)
            
            // MARK: Time Range Text
            Text(timeRangeText)
                .font(.body)
                .foregroundColor(.gray)
                .padding(.leading)
                .dynamicTypeSize(.xSmall ... .xxxLarge)
        }
        .accessibilityElement(children: .combine)
    }
}

struct TrendsDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsDetailInfoView(dataItems: DataItem.dailySampleData(), amount: 1500, amountTypeText: "DAILY", amountText: 1500, timeRangeText: "March 2, 2022")
            .environmentObject(DrinkModel(test: false, suiteName: nil))
    }
}
