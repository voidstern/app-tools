//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 27.03.24.
//

import Foundation
import SwiftUI

public struct PurchaseButtonStyle: ButtonStyle {
    public init() { }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
#if os(macOS)
            .font(.system(size: 15, weight: .regular))
            .frame(height: 44)
#else
            .font(.system(size: 19, weight: .semibold))
            .frame(height: 64)
#endif
            .foregroundStyle(.background)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background {
                LinearGradient(colors: [Color.accentColor.opacity(configuration.isPressed ? 0.9 : 0.8), Color.accentColor.opacity(configuration.isPressed ? 0.7 : 1.0)], startPoint: .top, endPoint: .bottom)
                    .opacity(configuration.isPressed ? 0.9 : 1.0)
                    .animation(.linear(duration: 0.1), value: configuration.isPressed)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(color: Color.accentColor.opacity(configuration.isPressed ? 0.2 : 0.4), radius: configuration.isPressed ? 12 : 16)
                
            }
    }
}
