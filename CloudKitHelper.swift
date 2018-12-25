//
//  CloudKitZones.swift
//  AppToolsMobile
//
//  Created by Lukas on 25.12.18.
//  Copyright © 2018 Lukas. All rights reserved.
//

import Foundation
import CloudKit

public protocol CloudKitHelperDelegate: class {
    func cloudKitHelper(_ helper: CloudKitHelper, didEncounter error: Error)
}

public class CloudKitHelper {
    public let database: CKDatabase
    public weak var delegate: CloudKitHelperDelegate?
    
    public init(database: CKDatabase) {
        self.database = database
    }
    
    // MARK: Fetching
    
    public func fetchAllZones() -> [CKRecordZone] {
        
        var fetchedZones: [CKRecordZone] = []
        let semaphore = DispatchSemaphore(value: 0)
        
        let fetchZonesOperation = CKFetchRecordZonesOperation.fetchAllRecordZonesOperation()
        fetchZonesOperation.qualityOfService = .utility
        fetchZonesOperation.fetchRecordZonesCompletionBlock = { (recordZones: [CKRecordZone.ID : CKRecordZone]?, error: Error?) -> Void in
            if let error = error {
                self.delegate?.cloudKitHelper(self, didEncounter: error)
            }
            
            if let values = recordZones?.values {
                fetchedZones = Array(values)
            }
            
            semaphore.signal()
        }
        
        database.add(fetchZonesOperation)
        semaphore.wait()
        
        return fetchedZones
    }
    
    public func fetchAll(ofType recordType: CKRecord.RecordType, with zoneID: CKRecordZone.ID? = nil) -> [CKRecord] {
        
        var fetchedRecords: [CKRecord] = []
        
        let query = CKQuery(recordType: recordType, predicate: NSPredicate.init(value: true))
        let semaphore = DispatchSemaphore(value: 0)
        
        // TODO: Use QueryOperation
        
        database.perform(query, inZoneWith: zoneID) { (records, error) in
            if let error = error {
                self.delegate?.cloudKitHelper(self, didEncounter: error)
            }
            
            fetchedRecords = records ?? []
            semaphore.signal()
        }
        
        semaphore.wait()
        
        return fetchedRecords
    }
    
    // MARK: Saving
    
    @discardableResult
    public func save(record: CKRecord) -> CKRecord? {
        
        let semaphore = DispatchSemaphore(value: 0)
        var fetchedRecord: CKRecord?
        
        database.save(record) { (record, error) in
            if let error = error {
                self.delegate?.cloudKitHelper(self, didEncounter: error)
            }
            
            fetchedRecord = record
            semaphore.signal()
        }
        
        semaphore.wait()
        return fetchedRecord
    }
    
    @discardableResult
    public func save(recordZone: CKRecordZone) -> CKRecordZone? {
        
        let semaphore = DispatchSemaphore(value: 0)
        var fetchedRecordZone: CKRecordZone?
        
        database.save(recordZone) { (zone, error) in
            if let error = error {
                self.delegate?.cloudKitHelper(self, didEncounter: error)
            }
            
            fetchedRecordZone = zone
            semaphore.signal()
        }
        
        semaphore.wait()
        return fetchedRecordZone
    }
    
    @discardableResult
    public func delete(recordZone: CKRecordZone) -> Bool {
        
        let semaphore = DispatchSemaphore(value: 0)
        var success = true
        
        database.delete(withRecordZoneID: recordZone.zoneID) { (zoneId, error) in
            if let error = error {
                self.delegate?.cloudKitHelper(self, didEncounter: error)
                success = false
            }
            
            semaphore.signal()
        }
        
        return success
    }
}
