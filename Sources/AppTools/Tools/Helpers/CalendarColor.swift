//
//  TaskGroupColor.swift
//  Focused
//
//  Created by Lukas Burgstaller on 28.02.24.
//

import Foundation
import SwiftUI

// Extracted Colors from Google Calendar
public enum CalendarColor: String, Codable, CaseIterable {
    case beetroot
    case cherryBlossom
    case tomato
    case flamingo
    
    case tangerine
    case pumpkin
    case mango
    case banana
    
    case citron
    case avocade
    case pistaccio
    case sage
    
    case basil
    case eucalyptus
    case peacock
    case cobalt
    
    case blueberry
    case lavender
    case wisteria
    case amethyst
    
    case grape
    case cocoa
    case graphite
    case birch
}

extension CalendarColor {
    public var color: Color {
        switch self {
        case .beetroot: return Color(hex: "#ab1656")
        case .cherryBlossom: return Color(hex: "#d51a5f")
        case .tomato: return Color(hex: "#d40000")
        case .flamingo: return Color(hex: "#e47b72")
            
        case .tangerine: return Color(hex: "#f4521e")
        case .pumpkin: return Color(hex: "#ef6c00")
        case .mango: return Color(hex: "#f19300")
        case .banana: return Color(hex: "#f6bf27")
            
        case .citron: return Color(hex: "#e5c441")
        case .avocade: return Color(hex: "#c0ca34")
        case .pistaccio: return Color(hex: "#7db343")
        case .sage: return Color(hex: "#33b679")
            
        case .basil: return Color(hex: "#0d8044")
        case .eucalyptus: return Color(hex: "#009788")
        case .peacock: return Color(hex: "#029be6")
        case .cobalt: return Color(hex: "#4385f5")
            
        case .blueberry: return Color(hex: "#3f51b5")
        case .lavender: return Color(hex: "#7a86cb")
        case .wisteria: return Color(hex: "#b39ddb")
        case .amethyst: return Color(hex: "#9e69b0")
            
        case .grape: return Color(hex: "#8e24aa")
        case .cocoa: return Color(hex: "#795548")
        case .graphite: return Color(hex: "#616161")
        case .birch: return Color(hex: "#a89b8e")
        }
    }
    
    public var title: String {
        switch self {
        case .beetroot: return "Beetroot"
        case .cherryBlossom: return "Cherry Blossom"
        case .tomato: return "Tomato"
        case .flamingo: return "Flamingo"
            
        case .tangerine: return "Tangerine"
        case .pumpkin: return "Pumpkin"
        case .mango: return "Mango"
        case .banana: return "Banana"
            
        case .citron: return "Citron"
        case .avocade: return "Avocado"
        case .pistaccio: return "Pistaccio"
        case .sage: return "Sage"
            
        case .basil: return "Basil"
        case .eucalyptus: return "Eucalyptus"
        case .peacock: return "Peacock"
        case .cobalt: return "Cobalt"
            
        case .blueberry: return "Blueberry"
        case .lavender: return "Lavender"
        case .wisteria: return "Wisteria"
        case .amethyst: return "Amethyst"
            
        case .grape: return "Grape"
        case .cocoa: return "Cocoa"
        case .graphite: return "Graphite"
        case .birch: return "Birch"
        }
    }
    
    public static var random: CalendarColor {
        return CalendarColor.allCases.randomElement() ?? .blueberry
    }
}

extension CalendarColor: Identifiable {
    public var id: String {
        return rawValue
    }
}

extension CalendarColor: Comparable {
    public static func < (lhs: CalendarColor, rhs: CalendarColor) -> Bool {
        guard let lhsIndex = Self.allCases.firstIndex(of: lhs) else {
            return true
        }
        
        guard let rhsIndex = self.allCases.firstIndex(of: rhs) else {
            return false
        }
        
        return lhsIndex > rhsIndex
    }
}
