//
//  File.swift
//  
//
//  Created by peak on 2022/7/29.
//

import Foundation

protocol Logging {
    func debug(_ message: String)
    func debug(_ message: String, prefix: String)
    
    func info(_ message: String)
    func info(_ message: String, prefix: String)
    
    func warning(_ message: String)
    func warning(_ message: String, prefix: String)
    
    func error(_ message: String)
    func error(_ message: String, prefix: String)
}
