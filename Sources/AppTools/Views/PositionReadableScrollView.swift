//
//  PositionReadableScrollView.swift
//  Focused
//
//  Created by Lukas Burgstaller on 08.07.24.
//

import Foundation
import SwiftUI

public struct PositionReadableScrollView<Content>: View where Content: View {
    var axes: Axis.Set = .vertical
    let content: () -> Content
    let onScroll: (CGFloat) -> Void
    
    public init(axes: Axis.Set, content: @escaping () -> Content, onScroll: @escaping (CGFloat) -> Void) {
        self.axes = axes
        self.content = content
        self.onScroll = onScroll
    }
    
    public var body: some View {
        ScrollView(axes) {
            content()
                .background(
                    GeometryReader { proxy in
                        let position = (
                            axes == .vertical ?
                            proxy.frame(in: .named("scrollID")).origin.y :
                            proxy.frame(in: .named("scrollID")).origin.x
                        )
                        
                        Color.clear
                            .onChange(of: position) {
                                onScroll(position)
                            }
                    }
                )
        }
        .coordinateSpace(.named("scrollID"))
    }
}
