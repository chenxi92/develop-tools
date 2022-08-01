//
//  WebsiteRunner.swift
//  
//
//  Created by 陈希 on 2022/7/31.
//

import Foundation

/// Inspire from JohnSundell/Publish
/// https://github.com/JohnSundell/Publish/blob/master/Sources/PublishCLICore/WebsiteRunner.swift
///
internal struct WebsiteRunner {
    let portNumber: Int
    let logger: Logging
    
    func run() throws {
        let serverQueue = DispatchQueue(label: "WebServer")
        let serverProcess = Process()
        let command = self.command
        
        if command.isEmpty {
            logger.warning("not find python3/python/ruby environment!")
            return
        }
        logger.info("execute command: \(command)")
        logger.info("Press ENTER to stop the server and exit")
        
        serverQueue.async {
            do {
                _ = try ExecuteCommand(command: command, process: serverProcess)
            } catch let error as ShellError {
                print(error.message)
            } catch {
                print(error.localizedDescription)
            }

            serverProcess.terminate()
            exit(1)
        }

        let input = readLine()
        logger.debug("received [\(input ?? "")], terminated.")
        serverProcess.terminate()
    }
    
    var command: String {
        if isPython3Exist() {
            return "python3 -m http.server \(portNumber)"
        } else if isPython2Exist() {
            return "python -m SimpleHTTPServer \(portNumber)"
        } else if isRubyExist() {
            return "ruby -run -e httpd . -p\(portNumber)"
        }
        return ""
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
