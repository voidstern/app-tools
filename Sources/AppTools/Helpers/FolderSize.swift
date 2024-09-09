//
//  FolderSize.swift
//  AppTools
//
//  Created by Lukas Burgstaller on 03.09.24.
//

import Foundation

// MARK: - URLFileAttribute
struct URLFileAttribute {
    private(set) var fileSize: UInt? = nil
    private(set) var creationDate: Date? = nil
    private(set) var modificationDate: Date? = nil
    
    init(url: URL) {
        let path = url.path
        guard let dictionary: [FileAttributeKey: Any] = try? FileManager.default
            .attributesOfItem(atPath: path) else {
            return
        }
        
        if dictionary.keys.contains(FileAttributeKey.size),
           let value = dictionary[FileAttributeKey.size] as? UInt {
            self.fileSize = value
        }
        
        if dictionary.keys.contains(FileAttributeKey.creationDate),
           let value = dictionary[FileAttributeKey.creationDate] as? Date {
            self.creationDate = value
        }
        
        if dictionary.keys.contains(FileAttributeKey.modificationDate),
           let value = dictionary[FileAttributeKey.modificationDate] as? Date {
            self.modificationDate = value
        }
    }
}

public extension URL {
    func directoryContents() -> [URL] {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil)
            return directoryContents
        } catch let error {
            print("Error: \(error)")
            return []
        }
    }
    
    func folderSize() -> UInt {
        let contents = self.directoryContents()
        var totalSize: UInt = 0
        contents.forEach { url in
            
            if url.hasDirectoryPath {
                totalSize += url.folderSize()
            } else {
                totalSize += url.fileSizeAtURL()
            }
        }
        return totalSize
    }
    
    func fileSizeAtURL() -> UInt {
        let attributes = URLFileAttribute(url: self)
        return attributes.fileSize ?? 0
    }
}
