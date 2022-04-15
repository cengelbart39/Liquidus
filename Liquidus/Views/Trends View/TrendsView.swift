//
//  TrendsView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 1/20/22.
//

import SwiftUI
import WidgetKit

struct TrendsView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.dynamicTypeSize) var dynamicType
    
    @ScaledMetric(relativeTo: .title3) var symbolSize1 = 40
    @ScaledMetric(relativeTo: .title3) var symbolSize2 = 30
    @ScaledMetric(relativeTo: .title3) var symbolSize3 = 20
    @ScaledMetric(relativeTo: .title3) var symbolSize4 = 10

    var body: some View {
        NavigationView {
            // Get all drink types
            let drinkTypes = [Constants.totalType] + model.drinkData.drinkTypes
            
            ScrollView {
                
                VStack(alignment: .leading) {
                    
                    // Loop through drink types
                    ForEach(drinkTypes) { type in
                        if type.enabled {
                            NavigationLink {
                                TrendsDetailView(type: type)
                            } label: {
                                
                                ZStack {
                                    // Background
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color(.systemGray6))
                                    
                                    HStack {
                                        let avg1 = model.getTypeAverage(type: type, startDate: .now)
                                        let avg2 = model.getTypeAverage(type: type, startDate: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now) ?? Date())
                                        
                                        // Trends Symbol
                                        TrendsSymbolView(type: type, avg1: avg1, avg2: avg2)
                                        
                                        // Text
                                        VStack(alignment: .leading) {
                                            Text(type.name)
                                                .font(self.getTypeFontStyle())
                                                .foregroundColor(.primary)
                                            
                                            TrendsAmountView(type: type, avg1: avg1)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color(.systemGray2))
                                    }
                                    .padding()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    Text("3 months-worth of consumption data is required to calculate a trend.")
                        .foregroundColor(.gray)
                        .font(.caption2)
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)
                }
            }
            .navigationTitle("Trends")
        }
    }
    
    /**
     Based on selected dynamic type size return a Font Style or Size
     */
    func getTypeFontStyle() -> Font {
        if !dynamicType.isAccessibilitySize {
            return .body
        } else if dynamicType == .accessibility1 {
            return .callout
        } else if dynamicType == .accessibility2 || dynamicType == .accessibility3 {
            return .footnote
        } else {
            return .system(size: 25)
        }
    }
    

}

struct TrendsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendsView()
    }
}
