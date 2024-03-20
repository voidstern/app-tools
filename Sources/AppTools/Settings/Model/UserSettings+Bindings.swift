//
//  File.swift
//
//
//  Created by Lukas Burgstaller on 30.10.23.
//

import Foundation
import SwiftUI

extension UserSettings {
    public func string(for key: UserSettings.Setting) -> Binding<String> {
        return Binding<String>(get: {
            UserSettings.shared.string(key: key)
        }, set: { value in
            DispatchQueue.onMainQueue {
                UserSettings.shared.set(value: value, key: key)
            }
        })
    }
    
    public func integer(for key: UserSettings.Setting) -> Binding<Int> {
        return Binding<Int>(get: {
            UserSettings.shared.integer(key: key)
        }, set: { value in
            DispatchQueue.onMainQueue {
                UserSettings.shared.set(value: value, key: key)
            }
        })
    }
    
    public func double(for key: UserSettings.Setting) -> Binding<Double> {
        return Binding<Double>(get: {
            UserSettings.shared.double(key: key)
        }, set: { value in
            DispatchQueue.onMainQueue {
                UserSettings.shared.set(value: value, key: key)
            }
        })
    }
    
    public func bool(for key: UserSettings.Setting) -> Binding<Bool> {
        return Binding<Bool>(get: {
            UserSettings.shared.bool(key: key)
        }, set: { value in
            DispatchQueue.onMainQueue {
                UserSettings.shared.set(value: value, key: key)
            }
        })
    }
}
