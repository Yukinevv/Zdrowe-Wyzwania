//
//  CircleView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 24/09/2023.
//

import Foundation
import SwiftUI

struct CircleView: View {
    private let shadowOffset: CGFloat = 8
    private let shadowRadius: CGFloat = 3
    private let shadowColor: Color = .foregroundGray
    private let highlightColor: Color = .white

    @AppStorage("isDarkMode") private var isDarkMode = true

    var body: some View {
        Circle().fill(isDarkMode ? .black : .white)
            .shadow(color: shadowColor, radius: shadowRadius, x: shadowOffset, y: shadowOffset)
            .shadow(color: isDarkMode ? .white : .black, radius: shadowRadius, x: -shadowOffset, y: -shadowOffset)
    }
}