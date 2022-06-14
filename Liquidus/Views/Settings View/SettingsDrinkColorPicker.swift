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
                drinkType.color = UIColor(newValue).encode()
            }
            // When view appears, update color to drinkType's color
            .onAppear {
                if let data = drinkType.color {
                    if let uiColor = UIColor.color(data: data) {
                        color = Color(uiColor: uiColor)
                    }
                }
            }
        
    }
}
