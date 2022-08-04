//
//  CloudKitZones.swift
//  AppToolsMobile
//
//  Created by Lukas on 25.12.18.
//  Copyright © 2018 Lukas. All rights reserved.
//

import Foundation
import CloudKit

@available(iOS 12.0, *)
public protocol CloudKitHelperDelegate: AnyObject {
    func cloudKitHelper(_ helper: CloudKitHelper, didEncounter error: Error)
}

@available(iOS 12.0, *)
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
    
    @available(iOSApplicationExtension 12.0, *)
    @available(watchOSApplicationExtension 5.0, *)
    public func fetchChanges(in zoneID: CKRecordZone.ID, changeToken: CKServerChangeToken?, recordChanged: @escaping (CKRecord) -> Void, recordDeleted: @escaping (CKRecord.ID, CKRecord.RecordType) -> Void) -> CKServerChangeToken? {
        let zoneConfiguration = CKFetchRecordZoneChangesOperation.ZoneConfiguration(previousServerChangeToken: changeToken, resultsLimit: nil, desiredKeys: nil)
        let operationConfiguration = CKFetchRecordZoneChangesOperation.Configuration()
        operationConfiguration.timeoutIntervalForRequest = 10
        operationConfiguration.timeoutIntervalForResource = 10
        operationConfiguration.isLongLived = false
        
        let fetchOperation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [zoneID], configurationsByRecordZoneID: [zoneID: zoneConfiguration])
        fetchOperation.configuration = operationConfiguration
        fetchOperation.fetchAllChanges = true
        
        var newChangeToken: CKServerChangeToken?
        let semaphore = DispatchSemaphore(value: 0)
        
        fetchOperation.recordChangedBlock = { (record) in
            recordChanged(record)
        }
        
        fetchOperation.recordWithIDWasDeletedBlock = { (recordID, recordType) in
            recordDeleted(recordID, recordType)
        }
        
        fetchOperation.recordZoneChangeTokensUpdatedBlock = { (zoneID, changeToken, clientChangeToken) in
            newChangeToken = changeToken
        }
        
        fetchOperation.recordZoneFetchCompletionBlock = { (zoneID, changeToken, clientChangeToken, moreComing, error) in
            newChangeToken = changeToken
        }
        
        fetchOperation.fetchRecordZoneChangesCompletionBlock = { (error) in
            if let error = error {
                self.delegate?.cloudKitHelper(self, didEncounter: error)
            }
            
            semaphore.signal()
        }
        
        database.add(fetchOperation)
        semaphore.wait()
        return newChangeToken
    }
    
    // MARK: Subscription
    
    @discardableResult
    public func save(subscription: CKSubscription) -> Bool {
        
        let semaphore = DispatchSemaphore(value: 0)
        var success = true
        
        database.save(subscription) { (subscription, error) in
            if let error = error {
                self.delegate?.cloudKitHelper(self, didEncounter: error)
                success = false
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return success
    }
    
    // MARK: Records
    
    @discardableResult
    public func save(records: [CKRecord]?, delete recordIDs: [CKRecord.ID]?) -> Bool {
        
        let semaphore = DispatchSemaphore(value: 0)
        var success = true
        
        let operationConfiguration = CKModifyRecordsOperation.Configuration()
        operationConfiguration.timeoutIntervalForRequest = 10
        operationConfiguration.timeoutIntervalForResource = 10
        operationConfiguration.isLongLived = false
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: recordIDs)
        operation.configuration = operationConfiguration
        operation.savePolicy = .allKeys
        
        
        operation.modifyRecordsCompletionBlock = { (records, deleted, error) in
            if let error = error {
                self.delegate?.cloudKitHelper(self, didEncounter: error)
                success = false
            }
            
            semaphore.signal()
        }
        
        database.add(operation)
        semaphore.wait()
        
        return success
    }
    
    @discardableResult
    public func save(record: CKRecord) -> Bool {
        return save(records: [record], delete: nil)
    }
    
    @discardableResult
    public func delete(with recordID: CKRecord.ID) -> Bool {
        return save(records: nil, delete: [recordID])
    }
    
    // MARK: Record Zones
    
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
    public func delete(with recordZoneID: CKRecordZone.ID) -> Bool {
        
        let semaphore = DispatchSemaphore(value: 0)
        var success = true
        
        database.delete(withRecordZoneID: recordZoneID) { (zoneId, error) in
            if let error = error {
                self.delegate?.cloudKitHelper(self, didEncounter: error)
                success = false
            }
            
            semaphore.signal()
        }
        
        return success
    }
}

public extension CKRecord {
    func removeAllFields() {
        let keys = allKeys()
        for key in keys {
            setObject(nil, forKey: key)
        }
    }
    
    func setValues(_ dictionary: [String: Any]) {
        removeAllFields()
        for key in dictionary.keys {
            if let value = dictionary[key] as? CKRecordValue {
                setObject(value, forKey: CKRecord.FieldKey(key))
            } else {
                print("Could not save \(dictionary[key] ?? "nil") for \(key)")
            }
        }
    }
    
    var values: [String: Any] {
        var values: [String: Any] = [:]
        
        for key in allKeys() {
            if let value = object(forKey: key) {
                values[key as String] = value
            }
        }
        
        return values
    }
}
