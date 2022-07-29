//
//  File.swift
//  
//
//  Created by peak on 2022/7/29.
//

import Foundation

final class ConsoleLogger: Logging {
    
    private let level: LogLevel
    init(level: LogLevel) {
        self.level = level
    }
    
    func debug(_ message: String) {
        debug(message, prefix: "")
    }
    func debug(_ message: String, prefix: String) {
        self.log(message, prefix: prefix, level: .debug)
    }
    
    func info(_ message: String) {
        info(message, prefix: "")
    }
    func info(_ message: String, prefix: String) {
        self.log(message, prefix: prefix, level: .info)
    }
    
    func warning(_ message: String) {
        warning(message, prefix: "")
    }
    func warning(_ message: String, prefix: String) {
        self.log(message, prefix: prefix, level: .warning)
    }
    
    func error(_ message: String) {
        error(message, prefix: "")
    }
    func error(_ message: String, prefix: String) {
        self.log(message, prefix: prefix, level: .error)
    }
    
    private func log(_ message: String, prefix: String, level: LogLevel) {
        guard self.level >= level else { return }
        
        print("\(prefix)\(compile(message, level: level))")
    }
    
    private func compile(_ message: String, level: LogLevel) -> String {
        return "===> \(level.prefix)\(message)".trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
