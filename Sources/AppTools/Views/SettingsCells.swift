//
//  SettingsCells.swift
//  Tidur Timers
//
//  Created by Lukas Burgstaller on 22.02.24.
//  Copyright © 2024 Lukas Burgstaller. All rights reserved.
//

import Foundation
import SwiftUI

public struct BooleanSettingsCell: View {
    let setting: UserSettings.Setting
    let storage: UserSettings
    let image: Image?
    let title: String
    let tint: Color
    
    public init(setting: UserSettings.Setting, storage: UserSettings = .shared, image: Image? = nil, title: String, tint: Color = .accentColor) {
        self.setting = setting
        self.storage = storage
        self.image = image
        self.title = title
        self.tint = tint
    }
    
    public var body: some View {
        HStack {
            if let image {
                image
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(tint)
                    .tint(tint)
            }
            
            Toggle(isOn: storage.binding(for: setting), label: {
                Text(title)
            })
        }
    }
}

public struct StepperSettingsCell: View {
    @ObservedObject var storage: UserSettings
    
    let setting: UserSettings.Setting
    let image: Image?
    let title: String
    let tint: Color
    
    public init(setting: UserSettings.Setting, storage: UserSettings = .shared, image: Image? = nil, title: String, tint: Color = .accentColor) {
        self.setting = setting
        self.storage = storage
        self.image = image
        self.title = title
        self.tint = tint
    }
    
    public var body: some View {
        HStack {
            if let image {
                image
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(tint)
                    .tint(tint)
            }
            

            HStack(spacing: 4) {
                Text("\(storage.integer(key: setting))")
                Stepper(title, value: binding)
            }
        }
    }
    
    private var binding: Binding<Int> {
        storage.binding(for: setting)
    }
}

public struct PickerSettingsCell: View {
    let setting: UserSettings.Setting
    let storage: UserSettings
    let image: Image?
    let title: String
    let tint: Color
    let options: [String]
    
    public init(setting: UserSettings.Setting, storage: UserSettings = .shared, image: Image? = nil, title: String, tint: Color = .accentColor, options: [String]) {
        self.setting = setting
        self.storage = storage
        self.image = image
        self.title = title
        self.tint = tint
        self.options = options
    }
    
    public var body: some View {
        HStack {
            if let image {
                image
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(tint)
                    .tint(tint)
            }
            
            Picker(selection: binding) {
                ForEach(Array(options.enumerated()), id: \.element) { index, option in
                    Text(option)
                        .tag(index)
                }
            } label: {
                Text(title)
            }

        }
    }
    
    var binding: Binding<Int> {
        storage.binding(for: setting)
    }
}

public struct ButtonSettingsCell: View {
    let image: Image?
    let title: String
    let tint: Color
    let isWorking: Bool
    
    let action: () -> ()
    
    public init(image: Image?, title: String, tint: Color = .accentColor, isWorking: Bool = false, action: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.tint = tint
        self.isWorking = isWorking
        self.action = action
    }
    
    public var body: some View {
        Button(action: action, label: {
            HStack {
                if let image {
                    image
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(tint)
                        .tint(tint)
                }
                
                Text(title)
                    .foregroundStyle(.primary)
                    .tint(.primary)
                
                Spacer()
                
                if isWorking {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.primary)
                }
            }
        })
    }
}

public struct NavigationSettingsCell<Destination: View>: View {
    let image: Image?
    let title: String
    let tint: Color
    let isWorking: Bool
    let destination: Destination
    
    public init(image: Image?, title: String, tint: Color = .accentColor, isWorking: Bool = false, destination: () -> Destination) {
        self.image = image
        self.title = title
        self.tint = tint
        self.isWorking = isWorking
        self.destination = destination()
    }
    
    public var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                if let image {
                    image
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(tint)
                        .tint(tint)
                }
                
                Text(title)
                    .foregroundStyle(.primary)
                    .tint(.primary)
                
                Spacer()
                
                if isWorking {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.primary)
                }
            }
        }
    }
}

public struct OtherAppSettingsCell: View {
    let appIcon: Image
    let title: String
    let subtitle: String
    
    let action: () -> ()
    
    public init(appIcon: Image, title: String, subtitle: String, action: @escaping () -> Void) {
        self.appIcon = appIcon
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    public var body: some View {
        Button(action: action, label: {
            HStack(spacing: 16) {
                appIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .fontWeight(.regular)
                        .foregroundStyle(.primary)
                        .tint(.primary)
                    Text(subtitle)
                        .fontWeight(.regular)
                        .opacity(0.5)
                        .foregroundStyle(.primary)
                        .tint(.primary)
                }
            }
        })
    }
}