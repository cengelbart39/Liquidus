//
//  IntentLogic.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 1/22/22.
//

import Foundation
import SwiftUI

class IntentLogic {
    
    static func getTotalAmountByDay(types: FetchedResults<DrinkType>, date: Date) -> Double {
        var amount = 0.0
        
        for type in types {
            amount += type.getTypeAmountByDay(day: Day(date: date))
        }
        
        return amount
    }
}
