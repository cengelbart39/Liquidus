//
//  AXDataPointEquatable.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/12/22.
//

import Foundation
import SwiftUI

extension AXDataPoint {
    static func == (lhs: AXDataPoint, rhs: AXDataPoint) -> Bool {
        
        if lhs.xValue.description == rhs.xValue.description {
            
            if let lhsYDescr = lhs.yValue?.description, let rhsYDescr = rhs.yValue?.description {
                
                if lhsYDescr == rhsYDescr { return true }
                
            } else if lhs.yValue == nil && rhs.yValue == nil {
                
                return true
                
            }
            
        }
        
        return false
    }
}
