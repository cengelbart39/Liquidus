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
        return lhs.xValue.description == rhs.xValue.description && lhs.yValue?.description == rhs.yValue?.description
    }
}
