//
//  File.swift
//  
//
//  Created by peak on 2022/7/29.
//

import Foundation
import ArgumentParser

struct HttpServer: ParsableCommand {
    static var configuration: CommandConfiguration {
        return .init(abstract: "Start a http server with specific port")
    }
    
    @Option(name: [.short, .long], help: "The port number, default is 8080")
    var port: Int = 8080
    
    @Option(name: [.short, .long], help: "The log level")
    private var logLevel: LogLevel = .info
    
    @Option(name: [.short, .long], help: "Indicate whether kill existed port if exist")
    private var force: Bool = false
    
    lazy var logger = ConsoleLogger(level: logLevel)
    
    mutating func run() throws {
        logger.info("🌍 Starting web server at http://localhost:\(port)")
        
        if force {
            logger.debug("try to kill port \(port) if needed")
            try killPortIfNeeded(portNumber: port)
        }
        /**
         python3 -m http.server
         python -m SimpleHTTPServer
         ruby -run -e httpd . -p
         */
        let runner = WebsiteRunner(portNumber: port, logger: logger)
        try runner.run()
    }
    
    private mutating func killPortIfNeeded(portNumber: Int) throws {
        do {
            _ = try ExecuteCommand(command: "kill -9 $(lsof -ti :\(portNumber))")
        } catch let error as ShellError {
            if error.terminationStatus != 1 {
                logger.error("kill port: \(portNumber) occur error.\ncode: \(error.terminationStatus)\nmessage: \(error.message)\noutput: \(error.output)")
            }
        }
    }
}
