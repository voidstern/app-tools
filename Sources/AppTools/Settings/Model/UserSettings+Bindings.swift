//
//  File.swift
//
//
//  Created by Lukas Burgstaller on 30.10.23.
//

import Foundation
import SwiftUI

extension UserSettings {
    public func stringBinding(for key: UserSettings.Setting) -> Binding<String> {
        return Binding<String>(get: {
            UserSettings.shared.string(for: key)
        }, set: { value in
            DispatchQueue.onMainQueue {
                UserSettings.shared.set(value: value, for: key)
            }
        })
    }
    
    public func integerBinding(for key: UserSettings.Setting) -> Binding<Int> {
        return Binding<Int>(get: {
            UserSettings.shared.integer(for: key)
        }, set: { value in
            DispatchQueue.onMainQueue {
                UserSettings.shared.set(value: value, for: key)
            }
        })
    }
    
    public func doubleBinding(for key: UserSettings.Setting) -> Binding<Double> {
        return Binding<Double>(get: {
            UserSettings.shared.double(for: key)
        }, set: { value in
            DispatchQueue.onMainQueue {
                UserSettings.shared.set(value: value, for: key)
            }
        })
    }
    
    public func boolBinding(for key: UserSettings.Setting) -> Binding<Bool> {
        return Binding<Bool>(get: {
            UserSettings.shared.bool(for: key)
        }, set: { value in
            DispatchQueue.onMainQueue {
                UserSettings.shared.set(value: value, for: key)
            }
        })
    }
}
