//
//  View+Extension.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import SwiftUI

// Zrodlo: https://www.avanderlee.com/swiftui/conditional-view-modifier/

extension View {
    /// Aplikuje podana transformacje, jesli podany warunek jest prawdziwy
    ///
    /// - Parameters:
    ///   - condition: Warunek do oceny
    ///   - transform: Transformacja do zastosowania na zrodlowym widoku
    /// - Returns: Albo oryginalny widok, albo zmodyfikowany widok, jezeli warunek jest prawdziwy
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func cardStyle() -> some View {
        padding()
            .background(Color("Card"))
            .cornerRadius(15)
    }
}
