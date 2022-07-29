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
        logger.info("Press ENTER to stop the server and exit")
        /**
         python3 -m http.server
         python -m SimpleHTTPServer
         ruby -run -e httpd . -p
         */
        let runner = WebsiteRunner(portNumber: port)
        try runner.run()
    }
    
    
}

internal struct WebsiteRunner {
    let portNumber: Int
    
    func run() throws {
        let serverQueue = DispatchQueue(label: "Publish.WebServer")
        let serverProcess = Process()
        
        serverQueue.async {
            do {
                if isPython3Exist() {
                    _ = try ExecuteCommand(
                        command: "python3 -m http.server \(self.portNumber)",
                        process: serverProcess
                    )
                } else if isPython2Exist() {
                    _ = try ExecuteCommand(
                        command: "python -m SimpleHTTPServer \(self.portNumber)",
                        process: serverProcess
                    )
                } else if isRubyExist() {
                    _ = try ExecuteCommand(
                        command: "ruby -run -e httpd . -p\(self.portNumber)",
                        process: serverProcess
                    )
                }
            } catch let error as ShellError {
                print(error.message)
            } catch {
                print(error.localizedDescription)
            }

            serverProcess.terminate()
            exit(1)
        }

        _ = readLine()
        serverProcess.terminate()
    }
    
    private func isPython3Exist() -> Bool {
        do {
            _ = try ExecuteCommand(command: "which python3")
            return true
        } catch {
            return false
        }
    }
    
    private func isPython2Exist() -> Bool {
        do {
            _ = try ExecuteCommand(command: "which python")
            return true
        } catch {
            return false
        }
    }
    
    private func isRubyExist() -> Bool {
        do {
            _ = try ExecuteCommand(command: "which ruby")
            return true
        } catch {
            return false
        }
    }
}
