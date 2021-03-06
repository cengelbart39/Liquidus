//
//  SampleDrinkAmounts.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/4/22.
//

import Foundation

/**
 A container class for static constants that store a set of amonts used in `SampleDrinks`, `SampleDataItems`, and `SampleAXDataPoints`
 */
class SampleDrinkAmounts {
    /**
     A sample set of Drink Amounts used for each hour in a day
     */
    static let day: [Double] = [
        50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 600, 550, 500, 450, 400, 350, 300, 250, 200, 150, 100, 50
    ]
    
    /**
     A sample set of Drink Amounts used for each day in a week
     */
    static let week: [Double] = [
        100, 200, 300, 400, 300, 200, 100
    ]
    
    /**
     A sample set of Drink Amounts used for each day in a month
     */
    static let month: [Double] = [
        50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 750, 700, 650, 600, 550, 500, 450, 400, 350, 300, 250, 200, 150, 100, 50
    ]
}
