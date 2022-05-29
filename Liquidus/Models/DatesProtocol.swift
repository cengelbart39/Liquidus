//
//  DatesProtocol.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 5/18/22.
//

import Foundation

/**
 A `protocol` for `Date`-related data
 */
protocol DatesProtocol: CustomStringConvertible, Equatable, Identifiable {
    /// The data type of `data`
    associatedtype DatesData
    
    /// The unique id of the conforming object
    var id: UUID { get set }
    
    /// The data representing the object
    var data: DatesData { get set }
    
    /// A description of the conforming object
    var description: String { get set }
    
    /// A variation of the description for accessibility purposes
    var accessibilityDescription: String { get set }
    
    init()
    init(date: Date)
}

extension DatesProtocol {
    /**
     Determine if two objects conforming to `DatesProtocol` are the same
     - Parameter other: Some object confirming to `DatesProtocol`
     - Returns: Whether or not two objects conforming to `DatesProtocol`; `true` if so; `false` if not
     */
    func isEqualTo<T: DatesProtocol>(other: T) -> Bool {
        if let o = other as? Self { return self == o }
        return false
    }
}
