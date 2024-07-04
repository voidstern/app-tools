//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 04.07.24.
//

import Foundation
import SwiftUI

public struct CalendarColorPickerView: View {
    let onColorPicked: (CalendarColor) -> ()
    
    public init(onColorPicked: @escaping (CalendarColor) -> Void) {
        self.onColorPicked = onColorPicked
    }
    
    public var body: some View {
        List {
            Section {
                ForEach(CalendarColor.allCases) { color in
                    Button(action: { onColorPicked(color) }, label: {
                        HStack {
                            CalendarColorTitleView(color: color)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    })
                    .buttonStyle(.plain)
                }
            }
        }
#if os(iOS)
        .listStyle(.insetGrouped)
#endif
    }
}

public struct CalendarColorTitleView: View {
    let color: CalendarColor
    let size: CGFloat
    
    public init(color: CalendarColor, size: CGFloat = 22) {
        self.color = color
        self.size = size
    }
    
    public var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(color.color)
                    .opacity(0.6)
                
                Circle()
                    .stroke(color.color, style: .init(lineWidth: 2), antialiased: true)
            }
            .frame(width: size, height: size)
            
            Text(color.title)
        }
    }
}


