//
//  FileManagerService.swift
//  fCam
//
//  Created by Muhammad M. Munir on 18/11/23.
//

import Foundation

final class FileManagerService {
    
    public static let shared = FileManagerService()
    
    private lazy var currentDirectoryURL: URL? = createDirectory()
    private let videoDirectory = "filteredvideo"
    private let fileManager = FileManager.default
    
    private init() {}
    
    private func getVideoDirectoryURL() -> URL? {
        do {
            let rootDirectoryURL = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return rootDirectoryURL.appendingPathComponent(videoDirectory)
        } catch {
            return nil
        }
    }
    
    private func createDirectory() -> URL? {
        guard let videoDirURL = getVideoDirectoryURL() else {
            fatalError("Home directory is missing")
        }
        
        do {
            try fileManager.createDirectory(
                at: videoDirURL,
                withIntermediateDirectories: false
            )
            
            return videoDirURL
        } catch CocoaError.fileWriteFileExists {
            return videoDirURL
        } catch {
            fatalError("Error while creating document directory.")
        }
    }
    
    public func createFileURL(_ fileURL: String) -> URL {
        currentDirectoryURL!.appendingPathComponent(fileURL)
    }
    
    public func removeFileURL(_ fileURL: URL) {
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            print("Failed to remove file at url: \(fileURL.absoluteString)")
        }
    }
    
    public func clearVideoDirectory() {
        do {
            guard let currentDirectoryURL else { return }
            
            let files = try fileManager.contentsOfDirectory(
                at: currentDirectoryURL,
                includingPropertiesForKeys: nil
            )
            for fileURL in files {
                removeFileURL(fileURL)
            }
        } catch {
            print("Failed to search files at url \(String(describing: currentDirectoryURL))")
        }
    }
}
