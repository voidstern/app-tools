//
//  LabelledDivider.swift
//  WalkieTalkie
//
//  Created by Lukas Burgstaller on 05.07.22.
//

import Foundation
import SwiftUI

public struct LabelledDivider: View {
    let label: String
    let horizontalPadding: CGFloat
    let color: Color
    let lineOpacity: Double

    public init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray, lineOpacity: Double = 0.5) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
        self.lineOpacity = lineOpacity
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Spacer()
                .background {
                    line
                }
            
            Text(label)
                .bold()
                .padding(.horizontal, horizontalPadding)
                .foregroundColor(color)
            
            Spacer()
                .background {
                    line
                }
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    var line: some View {
        HStack {
            color
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .opacity(lineOpacity)
        }
    }
}
