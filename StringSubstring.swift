//
//  StringSubstring.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 3/22/22.
//

import Foundation

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
