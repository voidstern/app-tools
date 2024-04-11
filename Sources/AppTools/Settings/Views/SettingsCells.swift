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
#if os(watchOS)
        content
            .tint(.primary)
#else
        Menu {
            Button(action: copyText, label: {
                Text(L10n.copy)
            })
        } label: {
            content
                .tint(.primary)
        }
        .tint(.primary)
#if os(macOS)
        .menuStyle(.borderlessButton)
        .listRowSeparator(.hidden, edges: .all)
#endif
#endif
    }
    
    private var content: some View {
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
            
            Spacer()
            
            Text(detailString)
                .lineLimit(3)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.primary)
                .opacity(0.5)
        }
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
    
    private func copyText() {
#if os(iOS)
        UIPasteboard.general.string = detailString
#endif
        
#if os(macOS)
        NSPasteboard.general.setString(detailString, forType: .string)
#endif
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
    
    public init(image: Image? = nil, title: String, tint: Color = .accentColor, isWorking: Bool = false, action: @escaping () -> Void) {
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
            .contentShape(Rectangle())
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
    
    public init(image: Image? = nil, title: String, tint: Color = .accentColor, isWorking: Bool = false, destination: () -> Destination) {
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
            .contentShape(Rectangle())
        })
#if os(macOS)
        .buttonStyle(.plain)
        .listRowSeparator(.hidden, edges: .all)
#endif
    }
}

public struct MultiPickerSettingsCell: View {
    @ObservedObject var storage: UserSettings
    
    let setting: UserSettings.Setting
    let image: Image?
    let title: String
    let subtitle: String?
    let tint: Color
    
    @State var showPopover: Bool = false
    
    public init(setting: UserSettings.Setting, storage: UserSettings = .shared, image: Image? = nil, title: String, subtitle: String? = nil, tint: Color = .accentColor) {
        self.setting = setting
        self.storage = storage
        self.image = image
        self.title = title
        self.subtitle = subtitle 
        self.tint = tint
    }
    
    public var body: some View {
#if os(iOS)
        NavigationLink(destination: pickerView) {
            label
        }
#endif
        
#if os(macOS)
        Button(action: { showPopover = true}, label: {
            label
        })
        .buttonStyle(.plain)
        .listRowSeparator(.hidden, edges: .all)
#endif
    }
    
    private var label: some View {
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
            
            Group {
                if let subtitle {
                    Text(subtitle)
                        .opacity(0.5)
                } else if selectedOptions.count > 1 {
                    Text(selectedOptions.first?.title ?? L10n.none)
                } else {
                    Text("\(selectedOptions.count)")
                }
            }
            .opacity(0.8)
#if os(macOS)
            .popover(isPresented: $showPopover, arrowEdge: .trailing, content: {
                macPickerView
            })
#endif
        }
    }
    
    private var selectedOptions: [UserSettings.Setting.Option] {
        let selectedValues = storage.integers(key: setting)
        return (setting.options ?? []).filter({ selectedValues.contains($0.value) })
    }
    
    private var macPickerView: some View {
        List {
            Section {
                ForEach(setting.options ?? []) { option in
                    Toggle(option.title, isOn: .init(get: {
                        storage.integers(key: setting).contains(option.value)
                    }, set: { value in
                        var selectedValues = storage.integers(key: setting)
                        
                        if selectedValues.contains(option.value) {
                            selectedValues.remove(option.value)
                        } else {
                            selectedValues.append(option.value)
                        }
                        
                        storage.set(integers: selectedValues, key: setting)
                    }))
                }
            }
        }
        .navigationTitle(title)
    }
    
    private var pickerView: some View {
        List {
            Section {
                ForEach(setting.options ?? []) { option in
                    HStack {
                        Text(option.title)
                        
                        Spacer()
                        
                        if storage.integers(key: setting).contains(option.value) {
                            Image(systemSymbol: .checkmark)
                                .foregroundStyle(.tint)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        var selectedValues = storage.integers(key: setting)
                        
                        if selectedValues.contains(option.value) {
                            selectedValues.remove(option.value)
                        } else {
                            selectedValues.append(option.value)
                        }
                        
                        storage.set(integers: selectedValues, key: setting)
                    }
                }
            }
        }
        .navigationTitle(title)
    }
}

