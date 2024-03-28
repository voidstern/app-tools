//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 28.03.24.
//

import Foundation

public struct AppIconPickerContext {
    let sections: [AppIconPickerView.AppIconSection]
    let level: SubscriptionManager.SubscriptionLevel
    
    public init(sections: [AppIconPickerView.AppIconSection], level: SubscriptionManager.SubscriptionLevel) {
        self.sections = sections
        self.level = level
    }
}

extension AppIconPickerView {
    public struct AppIcon: Identifiable {
        let name: String
        let preview: String
        
        init(name: String, preview: String) {
            self.name = name
            self.preview = preview
        }
        
        init(name: String) {
            self.name = name
            self.preview = "\(name)-60"
        }
        
        public var id: String {
            name
        }
    }

    public struct AppIconSection: Identifiable {
        let title: String
        let icons: [AppIconRow]
        
        public init(title: String, icons: [[String]]) {
            self.title = title
            self.icons = icons.map({ iconRow in
                AppIconRow(icons: iconRow.map({ AppIcon(name: $0) }))
            })
        }
        
        public var id: String {
            title
        }
    }

    public struct AppIconRow: Identifiable {
        let icons: [AppIcon]
        
        public var id: String {
            icons.map({ $0.name }).joined()
        }
    }
}
