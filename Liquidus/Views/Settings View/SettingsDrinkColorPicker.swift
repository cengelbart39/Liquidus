//
//  SettingsDrinkColorPicker.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 10/3/21.
//

import SwiftUI

struct SettingsDrinkColorPicker: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var drinkType: String
    @State var color = Color.black
    
    var body: some View {
        
        ColorPicker(drinkType, selection: $color, supportsOpacity: false)
            // When the color changes, update model
            .onChange(of: color) { newValue in
                model.drinkData.colors[drinkType]! = CodableColor(color: UIColor(color))
            }
            // When view appears, update color to drinkType's color
            .onAppear {
                color = model.drinkData.colors[drinkType]!.getColor()
            }
        
    }
}

struct SettingsDrinkColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        SettingsDrinkColorPicker(drinkType: "Water")
            .environmentObject(DrinkModel())
    }
}
