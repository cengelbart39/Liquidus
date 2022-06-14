//
//  StringSubstring.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 3/22/22.
//
//  String Extension by Paul Hudson
//  https://www.hackingwithswift.com/example-code/strings/how-to-read-a-single-character-from-a-string
//

import Foundation

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
