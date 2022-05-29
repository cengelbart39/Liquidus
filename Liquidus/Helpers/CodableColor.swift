//
//  CodableColor.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/3/21.
//
//  Code by Ky Leggiero on Stack Overflow: https://stackoverflow.com/questions/50928153/make-uicolor-codable
//

import Foundation
import SwiftUI

/**
 Represents a `Color` that can be saved along other information in `DrinkData`
 */
public struct CodableColor: Hashable {
    /// The`UIColor` representative
    var color: UIColor
    
    /**
     Returns the stored `UIColor` as a `Color`
     - Returns: A `UIColor` converted to a `Color`
     */
    func getColor() -> Color {
        return Color(self.color)
    }
}

extension CodableColor: Encodable {
    
    /**
     Encodes a `CodableColor
     - Parameter encoder: An `Encoder` to encode a `CodableColor`
     */
    public func encode(to encoder: Encoder) throws {
        let nsCoder = NSKeyedArchiver(requiringSecureCoding: true)
        color.encode(with: nsCoder)
        var container = encoder.unkeyedContainer()
        try container.encode(nsCoder.encodedData)
    }
}

extension CodableColor: Decodable {
    
    /**
     Decodes a `CodableColor`
     - Parameter decoder: A `Decoder` to decode `Data` to a `CodableColor`
     - Throws: `UnexpectedlyFoundNilError` if can't code a `UIColor`
     */
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let decodedData = try container.decode(Data.self)
        let nsCoder = try NSKeyedUnarchiver(forReadingFrom: decodedData)
        
        guard let color = UIColor(coder: nsCoder) else {
            struct UnexpectedlyFoundNilError: Error {}
            
            throw UnexpectedlyFoundNilError()
        }
        
        self.color = color
    }
    
}

public extension UIColor {
    
    /**
     Converts a `UIColor` to a `CodableColor`
     - Returns: A converted `UIColor`
     */
    func codable() -> CodableColor {
        return CodableColor(color: self)
    }
    
}
