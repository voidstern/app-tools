//
//  SettingsCells.swift
//  Tidur Timers
//
//  Created by Lukas Burgstaller on 22.02.24.
//  Copyright © 2024 Lukas Burgstaller. All rights reserved.
//

import Foundation
import SwiftUI

public struct ToggleSettingsCell: View {
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
            
            Toggle(isOn: storage.bool(for: setting), label: {
                Text(title)
            })
        }
#if os(macOS)
        .listRowSeparator(.hidden, edges: .all)
#endif
    }
}

public struct DetailsSettingsCell: View {
    @ObservedObject var storage: UserSettings
    
    let setting: UserSettings.Setting
    let type: DetailsType
    let image: Image?
    let title: String
    let tint: Color
    
    public init(setting: UserSettings.Setting, storage: UserSettings = .shared, image: Image? = nil, title: String, type: DetailsType, tint: Color = .accentColor) {
        self.setting = setting
        self.storage = storage
        self.image = image
        self.title = title
        self.tint = tint
        self.type = type
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
            Text(title)
            
            Spacer()
            
            Text(detailString)
                .opacity(0.5)
        }
#if os(macOS)
        .listRowSeparator(.hidden, edges: .all)
#endif
    }
    
    private var detailString: String {
        switch type {
        case .string:
            return storage.string(key: setting)
        case .date:
            let timeInterval = storage.double(key: setting)
            let date = Date(timeIntervalSince1970: timeInterval)
            return date.shortDateString
        }
    }
    
    public enum DetailsType {
        case string
        case date
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
                Stepper(title, value: storage.integer(for: setting))
            }
        }
#if os(macOS)
        .listRowSeparator(.hidden, edges: .all)
#endif
    }
}

public struct PickerSettingsCell: View {
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
            
            Picker(selection: storage.integer(for: setting)) {
                ForEach((setting.options ?? [])) { option in
                    Text(option.title)
                        .tag(option.value)
                }
            } label: {
                Text(title)
            }
            .tint(.secondary)

        }
#if os(macOS)
        .listRowSeparator(.hidden, edges: .all)
#endif
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
#if os(macOS)
        .buttonStyle(.plain)
        .listRowSeparator(.hidden, edges: .all)
#endif
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
#if os(macOS)
        .buttonStyle(.plain)
        .listRowSeparator(.hidden, edges: .all)
#endif
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
                
                Spacer()
            }
        })
#if os(macOS)
        .buttonStyle(.plain)
        .listRowSeparator(.hidden, edges: .all)
#endif
    }
}

extension UserSettings.Setting.Option: Identifiable {
    public var id: Int {
        self.value
    }
}
