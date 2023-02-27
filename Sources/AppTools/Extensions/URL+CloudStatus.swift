//
//  URL+CloudStatus.swift
//  Scanner
//
//  Created by Lukas Burgstaller on 15.02.23.
//

import Foundation

public enum CloudStatus {
    case downloading
    case uploading
    case local
    case remote
    case synced
    case none
}

public extension URL {
    var cloudStatus: CloudStatus {
        var keys = Set<URLResourceKey>()
        keys.insert(.ubiquitousItemIsUploadingKey)
        keys.insert(.ubiquitousItemIsDownloadingKey)
        keys.insert(.ubiquitousItemIsUploadedKey)
        
        let values = try? resourceValues(forKeys: keys)
        let cloudValues = try? cloudItemURL?.resourceValues(forKeys: keys)
        let isUploaded = values?.ubiquitousItemIsUploaded == true || cloudValues?.ubiquitousItemIsUploaded == true
        let isUploading = values?.ubiquitousItemIsUploading == true || cloudValues?.ubiquitousItemIsUploading == true
        let isDownloading = values?.ubiquitousItemIsDownloading == true || cloudValues?.ubiquitousItemIsDownloading == true
        let cloudItemExists = cloudItemURL?.fileExists == true
        
        if lastPathComponent.hasSuffix(".icloud") {
            return .remote
        }
        
        if isUploading {
            return .uploading
        }
        
        if isDownloading {
            return .downloading
        }
        
        if fileExists && isUploaded {
            return .synced
        }
        
        if fileExists {
            return .local
        }
        
        if isUploaded || cloudItemExists {
            return .remote
        }
        
        return .none
    }
    
    var fileExists: Bool {
        guard isFileURL else {
            return false
        }
        
        return FileManager.default.fileExists(atPath: path)
    }
    
    var cloudItemURL: URL? {
        guard isFileURL else {
            return nil
        }
        
        if #available(iOS 16.0, watchOS 9.0, *) {
            return deletingLastPathComponent().appending(component: ".\(lastPathComponent).icloud", directoryHint: .checkFileSystem)
        } else {
            return deletingLastPathComponent().appendingPathComponent(".\(lastPathComponent).icloud")
        }
    }
    
    var lastModified: Date? {
        guard fileExists else {
            return nil
        }
        
        let attr = try? FileManager.default.attributesOfItem(atPath: path)
        return attr?[FileAttributeKey.modificationDate] as? Date
    }
    
    func startDownload(completion: ((URL?)->())? = nil) throws {
        try FileManager.default.startDownloadingUbiquitousItem(at: self)
        
        let coordinator = NSFileCoordinator(filePresenter: nil)
        let error: NSErrorPointer = nil
        
        DispatchQueue(label: "co.rocket-apps.ios.scanner.icloud-download").async {
            coordinator.coordinate(readingItemAt: self, error: error) { newURL in
                completion?(newURL)
            }
            
            if ((error?.pointee) != nil) {
                completion?(nil)
            }
        }
    }
    
    func folderContents() throws -> [URL] {
        guard isFileURL else {
            return []
        }
        
        let contents: [String] = try FileManager.default.contentsOfDirectory(atPath: path)
        if #available(iOS 16.0, watchOS 9.0, *) {
            return contents.map({ self.appending(component: $0, directoryHint: .checkFileSystem) })
        } else {
            return contents.map({ self.appendingPathComponent($0) })
        }
    }
    
    func fileContents() throws -> Data? {
        guard isFileURL else {
            return nil
        }
        
        return try Data(contentsOf: self)
    }
}

