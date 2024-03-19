//
//  SelectAllTextModifier.swift
//  TV Remote
//
//  Created by Lukas Burgstaller on 19.10.23.
//

import Foundation
import SwiftUI

#if !os(watchOS)
///https://stackoverflow.com/questions/67502138/select-all-text-in-textfield-upon-click-swiftui
public struct SelectAllTextOnBeginEditingModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(
                for: UITextField.textDidBeginEditingNotification)) { _ in
                    DispatchQueue.main.async {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil
                        )
                    }
                }
        }
}
#endif

extension View {
#if !os(watchOS)
    public func selectAllTextOnBeginEditing() -> some View {
        modifier(SelectAllTextOnBeginEditingModifier())
    }
#else
    public func selectAllTextOnBeginEditing() -> some View {
        return self
    }
#endif
}
