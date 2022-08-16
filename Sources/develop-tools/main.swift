import ArgumentParser

struct ToolKit: ParsableCommand {
    static var configuration: CommandConfiguration {
        return CommandConfiguration(
            commandName: "develop-tool",
            abstract: "A cli tool for develop",
            version: "1.0.0",
            subcommands: [KillProcess.self, HttpServer.self, GIFMaker.self]
        )
    }
}

ToolKit.main()
