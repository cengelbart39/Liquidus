//
//  UIColorExtension.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 5/31/22.
//

import Foundation
import UIKit

extension UIColor {
    
    class func color(data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
    
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
    }
}
