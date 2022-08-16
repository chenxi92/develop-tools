//
//  File.swift
//  
//
//  Created by peak on 2022/8/16.
//

import Foundation
import ArgumentParser
import Cocoa
import CoreGraphics
import UniformTypeIdentifiers

struct GIFMaker: ParsableCommand {
    static var configuration: CommandConfiguration {
        return .init(abstract: "A gif maker tool")
    }

    @Argument(help: "The images file to generate gif")
    var images: [String] = []
    
    @Option(name: [.short, .long], help: "The output file name")
    private var output: String?
    
    @Option(name: [.short, .long], help: "The amount of time, in seconds, to wait before displaying the next image in an animated sequence")
    private var delayTime: Int = 2
    
    @Option(name: [.short, .long], help: "The log level")
    private var logLevel: LogLevel = .info
    
    lazy var logger = ConsoleLogger(level: logLevel)
    
    mutating func run() throws {
        let urls: [URL] = buildValidImageURL()
        if urls.isEmpty {
            logger.warning("please type valid png/jpg image file names")
            return
        }
        urls.forEach { logger.info("image: \($0.lastPathComponent)")}
        
        let images = urls.compactMap { NSImage(contentsOf: $0) }
        if images.isEmpty {
            logger.warning("empty image")
            return
        }
        
        let fileName = output ?? UUID().uuidString
        let destinationDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let destinationURL = destinationDir.appendingPathComponent(fileName + ".gif")
        
        let isSuccess = generate(images: images, delayTime: delayTime, at: destinationURL)
        
        if isSuccess {
            NSWorkspace.shared.selectFile(destinationDir.path, inFileViewerRootedAtPath: "")
            logger.info("create gif success in: \(destinationURL.path)")
        }
    }
    
    mutating private func generate(images: [NSImage], delayTime: Int, at destinationURL: URL) -> Bool {
        guard let animatedGifFile = CGImageDestinationCreateWithURL(destinationURL as CFURL, UTType.gif.identifier as CFString, images.count, nil) else {
            logger.error("creating gif file error")
            return false
        }
        
        let fileDictionary = [
            kCGImagePropertyGIFDictionary: [
                kCGImagePropertyGIFLoopCount: 0
            ]
        ]
        CGImageDestinationSetProperties(animatedGifFile, fileDictionary as CFDictionary)
        
        let frameDictionary = [
            kCGImagePropertyGIFDictionary: [
                kCGImagePropertyGIFDelayTime: delayTime
            ]
        ]
        for image in images {
            let cgImage: CGImage = image.cgImage!
            CGImageDestinationAddImage(animatedGifFile, cgImage, frameDictionary as CFDictionary)
        }
        
        if CGImageDestinationFinalize(animatedGifFile) {
            return true
        }
        logger.error("generate gif file error")
        
        return false
    }
    
    private func buildValidImageURL() -> [URL] {
        images.filter { path in
            let url: URL
            if path.starts(with: "/") {
                url = URL(fileURLWithPath: path)
            } else {
                url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(path)
            }
            return FileManager.default.fileExists(atPath: url.path)
        }
        .map { URL(fileURLWithPath: $0)}
        .filter { $0.pathExtension == "png" || $0.pathExtension == "jpg"}
    }
}

private extension NSImage {
    var cgImage: CGImage? {
        var proposedRect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &proposedRect, context: nil, hints: nil)
    }
}
