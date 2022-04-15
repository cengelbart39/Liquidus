//
//  CodableColor.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 10/3/21.
//
//  Code by Ky Leggiero on Stack Overflow: https://stackoverflow.com/questions/50928153/make-uicolor-codable
//

import Foundation
import SwiftUI

public struct CodableColor: Hashable {
    var color: UIColor
    
    func getColor() -> Color {
        return Color(self.color)
    }
}

extension CodableColor: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        let nsCoder = NSKeyedArchiver(requiringSecureCoding: true)
        color.encode(with: nsCoder)
        var container = encoder.unkeyedContainer()
        try container.encode(nsCoder.encodedData)
    }
}

extension CodableColor: Decodable {
    
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
    
    func codable() -> CodableColor {
        return CodableColor(color: self)
    }
    
}
