//
//  SettingsDrinkColorPicker.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/3/21.
//

import SwiftUI

struct SettingsDrinkColorPicker: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var drinkType: DrinkType
    @State var color = Color.black
    
    var body: some View {
        
        ColorPicker(drinkType.name, selection: $color, supportsOpacity: false)
            // When the color changes, update model
            .onChange(of: color) { newValue in
                if let index = model.drinkData.drinkTypes.firstIndex(of: drinkType) {
                    model.drinkData.drinkTypes[index].color = CodableColor(color: UIColor(color))
                    model.drinkData.drinkTypes[index].colorChanged = true
                }
            }
            // When view appears, update color to drinkType's color
            .onAppear {
                if let index = model.drinkData.drinkTypes.firstIndex(of: drinkType) {
                    color = model.drinkData.drinkTypes[index].color.getColor()
                }
            }
        
    }
}
