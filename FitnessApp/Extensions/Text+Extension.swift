//
//  Text+Extension.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import SwiftUI

extension Text {
    func workoutSubheadlineStyle() -> Text {
        font(.subheadline).bold().foregroundColor(Color(UIColor.systemGray))
    }

    func workoutTitleStyle() -> Text {
        font(.title3).bold().foregroundColor(.white)
    }
}
