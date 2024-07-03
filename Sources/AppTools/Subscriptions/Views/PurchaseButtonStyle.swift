//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 27.03.24.
//

import Foundation
import SwiftUI

public struct PurchaseButtonStyle: ButtonStyle {
    let foregroundInverted: Bool
    
    public init(foregroundInverted: Bool? = nil) {
#if os(visionOS)
        self.foregroundInverted = foregroundInverted ?? false
#else
        self.foregroundInverted = foregroundInverted ?? true
#endif
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
#if os(macOS)
            .font(.system(size: 15, weight: .regular))
            .frame(height: 44)
#else
            .font(.system(size: 19, weight: .semibold))
            .frame(height: 64)
#endif
#if os(visionOS)
            .frame(depth: 20)
            .foregroundStyle(foregroundInverted ? .white : .black)
#else
            .if(foregroundInverted, transform: { $0.foregroundStyle(.background) }, else: { $0.foregroundStyle(.primary) })
#endif
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background {
                LinearGradient(colors: [Color.accentColor.opacity(configuration.isPressed ? 0.9 : 0.8), Color.accentColor.opacity(configuration.isPressed ? 0.7 : 1.0)], startPoint: .top, endPoint: .bottom)
                    .opacity(configuration.isPressed ? 0.9 : 1.0)
                    .animation(.linear(duration: 0.1), value: configuration.isPressed)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(color: Color.accentColor.opacity(configuration.isPressed ? 0.2 : 0.4), radius: configuration.isPressed ? 12 : 16)
                
            }
#if os(visionOS)
            .frame(depth: 50)
#endif
    }
}
