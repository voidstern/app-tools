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

    public init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    public var body: some View {
        HStack {
            line
            Text(label).foregroundColor(color).bold()
            line
        }
    }

    var line: some View {
        VStack { Divider().background(color) }.padding(horizontalPadding)
    }
}