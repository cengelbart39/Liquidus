//
//  TrendsDetailChartView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 3/2/22.
//

import SwiftUI

struct TrendsDetailChartView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var timePeriod: Constants.TimePeriod
    var type: String
    var dataItems: [DataItem]

    var amount: Double
    var maxValue: Double
    
    var verticalAxisText: [String]
    var horizontalAxisText: [String]
    
    var chartAccessibilityLabel: String
    
    var chartSpacerWidth: CGFloat
    
    var isWidget: Bool
    var isYear: Bool
    
    @Binding var halfYearOffset: Int
    @Binding var monthOffset: Int
    
    @Binding var touchLocation: Int

    
    var body: some View {
        ZStack {
            if !isWidget {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(.systemGray6))
                    .onTapGesture {
                        touchLocation = -1
                    }
            }
            
            HStack {
                ZStack {
                    // MARK: Vertical Axis
                    HStack() {
                        
                        ForEach(0..<verticalAxisText.count, id: \.self) { _ in
                            TrendsDetailChartYAxisGridlines()

                            Spacer()
                        }
                        
                        Rectangle()
                            .foregroundColor(Color(.systemGray5))
                            .frame(width: 1.5)
                            .padding(.bottom, isWidget ? 0 : 20)
                    }
                    
                    // MARK: Horizontal Axis Lines
                    VStack {
                        Rectangle()
                            .foregroundColor(Color(.systemGray5))
                            .frame(height: 1.5)
                        
                        Spacer()
                        
                        Rectangle()
                            .foregroundColor(Color(.systemGray5))
                            .frame(height: 1.5)
                        
                        Spacer()
                        
                        Rectangle()
                            .foregroundColor(Color(.systemGray5))
                            .frame(height: 1.5)
                        
                        Spacer()
                        
                        Rectangle()
                            .foregroundColor(Color(.systemGray5))
                            .frame(height: 1.5)
                            .padding(.bottom, isWidget ? 0 : 20)
                        
                    }
                    
                    // MARK: Bars
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            ForEach(dataItems) { item in
                                
                                TrendsDetailChartBarView(item: item, value: normalizedValue(item: item, maxValue: self.getAxisMaxValue(maxValue: maxValue)), type: type, isWidget: isWidget)
                                    .accessibilityChartDescriptor(self)
                                    .opacity(touchLocation == -1 ? 1 : (touchLocation == dataItems.firstIndex(of: item) ? 1 : 0.7))
                                    .onTapGesture {
                                        if let selectedItem = dataItems.firstIndex(of: item) {
                                            if touchLocation == selectedItem {
                                                touchLocation = -1
                                            } else {
                                                touchLocation = selectedItem
                                            }
                                        }
                                    }
                                
                                Spacer()
                                    .frame(maxWidth: chartSpacerWidth)
                            }
                            
                        }
                        
                        if !isWidget {
                            HStack {
                                ForEach(verticalAxisText, id: \.self) { text in
                                    
                                    Text(timePeriod != .yearly ? text : text[0])
                                        .foregroundColor(Color(.systemGray))
                                        .font(.caption)
                                        .dynamicTypeSize(.large)
                                    
                                    Spacer()
                                    
                                }
                            }
                        }
                    }
                }
                
                // MARK: Horizontal Axis Text
                if !isWidget {
                    let label = horizontalAxisText
                    
                    if amount != 0 {
                        VStack(alignment: .leading) {
                            Text(label[0])
                            
                            Spacer()
                            
                            Text(label[1])
                            
                            Spacer()
                            
                            Text(label[2])
                            
                            Spacer()
                            
                            Text(label[3])
                        }
                        .foregroundColor(Color(.systemGray))
                        .dynamicTypeSize(.large)
                        .font(.caption)
                        .padding(.top, -4)
                        .padding(.bottom, 20)
                    }
                }
            }
            .padding([.horizontal, .top], isWidget ? 0 : 20)
            .padding(.leading, isWidget ? 10 : 0)
            .padding(.bottom, isWidget ? 0 : 10)
            
        }
        .accessibilityElement(children: .combine)
    }
    
    /**
     For a data item and max value, divide the data item's total amount by the max value and return this value. When a data item has no amount, return 0.
     */
    func normalizedValue(item: DataItem, maxValue: Double) -> Double {
        // If max zero isn't zero divide
        if maxValue > 0 {
            return item.getIndividualAmount()/maxValue
        
        // If max is 0 return 0
        } else {
            return 0
        }
    }
    
    private func getAxisMaxValue(maxValue: Double) -> Double {
        var newAmount = maxValue
        while Int(ceil(newAmount)) % 3 != 0 {
            newAmount += 100
        }
        
        return newAmount
    }
}
