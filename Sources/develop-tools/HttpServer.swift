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
    
    lazy var logger = ConsoleLogger(level: logLevel)
    
    mutating func run() throws {
        logger.info("🌍 Starting web server at http://localhost:\(port)")
        
        /**
         python3 -m http.server
         python -m SimpleHTTPServer
         ruby -run -e httpd . -p
         */
        let runner = WebsiteRunner(portNumber: port, logger: logger)
        try runner.run()
    }
}
