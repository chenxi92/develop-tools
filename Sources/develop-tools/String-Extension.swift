//
//  File.swift
//  
//
//  Created by peak on 2022/7/29.
//

import Foundation

extension String {
    func toInt() -> Int {
        return Int(self.escapingSpaces.escapinsBreaklines) ?? 0
    }
    
    var escapingSpaces: String {
        replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\t", with: "")
    }
    
    var escapinsBreaklines: String {
        replacingOccurrences(of: "\n", with: "")
    }
}
