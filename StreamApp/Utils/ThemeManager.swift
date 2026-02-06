//
//  ThemeManager.swift
//  StreamApp
//
//  Created by Cours on 06/02/2026.
//

import SwiftUI
internal import Combine

enum Theme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
}


class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") var selectedTheme: String = Theme.system.rawValue
    
    init() {}
        
    var colorScheme: ColorScheme? {
        switch Theme(rawValue: selectedTheme) {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil //nil va suivre le thème système
        default:
            return nil
        }
    }
}
