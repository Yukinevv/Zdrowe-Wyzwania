//
//  ProgressCircleViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 07/05/2023.
//

import Foundation

struct ProgressCircleViewModel {
    let title: String
    let message: String
    let percentageComplete: Double
    var shouldShowTitle: Bool {
        percentageComplete <= 1
    }
}
