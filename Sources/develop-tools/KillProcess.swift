//
//  File.swift
//  
//
//  Created by peak on 2022/7/29.
//

import ArgumentParser

struct KillProcess: ParsableCommand {
    static var configuration: CommandConfiguration {
        return .init(abstract: "kill running process with specific port.")
    }
    
    @Argument var port: String
    
    @Option(name: [.short, .long], help: "The log level")
    private var logLevel: LogLevel = .info
    
    lazy var logger = ConsoleLogger(level: logLevel)
    
    mutating func run() throws {
        logger.info("start kill process on port: \(port)")
        do {
            _ = try ExecuteCommand(command: "kill -9 $(lsof -ti :\(port))")
            logger.info("kill success on port \(port)")
        } catch let error as ShellError {
            if error.terminationStatus == 1 {
                logger.warning("not find pid on port: \(port)")
            } else {
                logger.error("code: \(error.terminationStatus)\nmessage: \(error.message)\noutput: \(error.output)")
            }
        }
    }
}



