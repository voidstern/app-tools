//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 30.10.23.
//

import Foundation
import AppTools
import SwiftUI

extension UserSettings {
    public func binding(for key: UserSettings.Setting) -> Binding<String> {
        return Binding<String>(get: {
            UserSettings.shared.string(key: key)
        }, set: { value in
            UserSettings.shared.set(value: value, key: key)
        })
    }
    
    public func binding(for key: UserSettings.Setting) -> Binding<Int> {
        return Binding<Int>(get: {
            UserSettings.shared.integer(key: key)
        }, set: { value in
            UserSettings.shared.set(value: value, key: key)
        })
    }
    
    public func binding(for key: UserSettings.Setting) -> Binding<Bool> {
        return Binding<Bool>(get: {
            UserSettings.shared.bool(key: key)
        }, set: { value in
            UserSettings.shared.set(value: value, key: key)
        })
    }
}
