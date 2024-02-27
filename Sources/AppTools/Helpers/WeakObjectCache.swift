//
//  WeakObjectCache.swift
//  TaskList
//
//  Created by Lukas on 20.11.19.
//  Copyright © 2019 Cocoacake. All rights reserved.
//

import Foundation


public class WeakObjectCache<ObjectType: AnyObject> {
    private var objects: [String: WeakObject<ObjectType>] = [:]
    private let maxObjects: Int?
    
    public init(maxObjects: Int? = nil) {
        self.maxObjects = maxObjects
    }
    
    private struct WeakObject<T: AnyObject> {
        weak var object: T?
    }
    
    @discardableResult
    public func add(object: ObjectType, identifier: String) -> Bool {
        guard self.object(with: identifier) == nil else {
            return false
        }
        
        objects[identifier] = WeakObject<ObjectType>(object: object)
        return true
    }
    
    public func object(with identifier: String) -> ObjectType? {
        cleanObjectsCache()
        return objects[identifier]?.object
    }
    
    public func removeObject(with identifier: String) {
        return objects[identifier] = nil
    }
    
    public func removeAllObjects() {
        return objects.removeAll()
    }
    
    func cleanObjectsCache() {
        objects = objects.filter({ $1.object != nil })
    }
    
}
