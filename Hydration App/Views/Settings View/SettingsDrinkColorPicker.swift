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
            .onChange(of: color) { newValue in
                model.drinkData.colors[drinkType]! = CodableColor(color: UIColor(color))
            }
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
