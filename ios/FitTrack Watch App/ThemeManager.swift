//
//  ThemeManager.swift
//  FitTrack Watch App
//
//  Created by Tan Quan Ming on 16/06/2024.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var primary = Color("#1A1A1A")
    @Published var primaryBright = Color("#333333")
    @Published var secondary = Color("#E1F0CF")
    @Published var secondaryDark = Color(red: 153, green: 179, blue: 145)
    @Published var secondaryLight = Color("#C1C1C1")
}
