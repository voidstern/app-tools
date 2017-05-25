//
//  FileMonitor.swift
//  Multi Timers 2
//
//  Created by Lukas Burgstaller on 11/01/16.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation

enum FileMonitorChangeType {
    case modified
    case metadata
    case size
    case renamed
    case deleted
    case objectLink
    case revoked
}

protocol FileMonitorDelegate {
    func fileMonitorDidSeeChange(_ fileMonitor: FileMonitor, change: FileMonitorChangeType)
}

class FileMonitor {
    var delegate: FileMonitorDelegate?

    fileprivate var fileURL: URL?
    fileprivate var source: DispatchSource?
    fileprivate var fileDescriptor: CInt = 0
    fileprivate var keepMonitoring: Bool = false

    init(url: URL) {
        fileURL = url
        self.beginMonitoringFile()
    }

    init(url: URL, delegate: FileMonitorDelegate) {
        self.fileURL = url
        self.delegate = delegate
        self.beginMonitoringFile()
    }

    deinit {
        if source != nil {
            source!.cancel()
        }
    }

    @discardableResult func beginMonitoringFile() -> Bool {
        guard fileURL != nil else {
            return false
        }

        fileDescriptor = open((fileURL! as NSURL).fileSystemRepresentation, O_EVTONLY)


        guard fileDescriptor > 0 else {
            return false
        }

        let defaultQueue = DispatchQueue.global(qos: DispatchQoS.background.qosClass)

        let mask = DispatchSource.FileSystemEvent.attrib.rawValue | DispatchSource.FileSystemEvent.delete.rawValue | DispatchSource.FileSystemEvent.extend.rawValue | DispatchSource.FileSystemEvent.link.rawValue | DispatchSource.FileSystemEvent.rename.rawValue | DispatchSource.FileSystemEvent.revoke.rawValue | DispatchSource.FileSystemEvent.write.rawValue

        source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: DispatchSource.FileSystemEvent(rawValue: mask), queue: defaultQueue) /*Migrator FIXME: Use DispatchSourceFileSystemObject to avoid the cast*/ as? DispatchSource

        guard source != nil else {
            return false
        }

        source!.setEventHandler { () -> Void in

            guard self.source != nil else {
                return
            }

            if let source : DispatchSourceProtocol = self.source {
                let eventTypes = source.data
                self.alertDelegateOfEvents(eventTypes)
            }

        }

        source!.setCancelHandler { () -> Void in
            close(self.fileDescriptor)
            self.fileDescriptor = 0
            self.source = nil

            if self.keepMonitoring {
                self.keepMonitoring = false
                self.beginMonitoringFile()
            }
        }

        // Start monitoring the test file
        source!.resume();

        return true
    }

    func recreateDispatchSource() {
        guard source != nil else {
            return
        }

        keepMonitoring = true
        source!.cancel()
    }

    func alertDelegateOfEvents(_ eventTypes: UInt) {
        DispatchQueue.main.async { () -> Void in
            var recreateDispatchSource = false

            guard self.delegate != nil else {
                return
            }

            if (eventTypes & DispatchSource.FileSystemEvent.attrib.rawValue) != 0 {
                self.delegate!.fileMonitorDidSeeChange(self, change: FileMonitorChangeType.metadata)
            }

            if (eventTypes & DispatchSource.FileSystemEvent.delete.rawValue) != 0  {
                self.delegate!.fileMonitorDidSeeChange(self, change: FileMonitorChangeType.deleted)
                recreateDispatchSource = true
            }

            if (eventTypes & DispatchSource.FileSystemEvent.extend.rawValue) != 0  {
                self.delegate!.fileMonitorDidSeeChange(self, change: FileMonitorChangeType.size)
            }

            if (eventTypes & DispatchSource.FileSystemEvent.link.rawValue) != 0  {
                self.delegate!.fileMonitorDidSeeChange(self, change: FileMonitorChangeType.objectLink)
            }

            if (eventTypes & DispatchSource.FileSystemEvent.rename.rawValue) != 0  {
                self.delegate!.fileMonitorDidSeeChange(self, change: FileMonitorChangeType.renamed)
                recreateDispatchSource = true
            }

            if (eventTypes & DispatchSource.FileSystemEvent.revoke.rawValue) != 0  {
                self.delegate!.fileMonitorDidSeeChange(self, change: FileMonitorChangeType.revoked)
            }

            if (eventTypes & DispatchSource.FileSystemEvent.write.rawValue) != 0  {
                self.delegate!.fileMonitorDidSeeChange(self, change: FileMonitorChangeType.modified)
            }

            if recreateDispatchSource {
                self.recreateDispatchSource()
            }
        }
    }
}
