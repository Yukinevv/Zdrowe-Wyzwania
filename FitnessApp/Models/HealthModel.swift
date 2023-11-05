//
//  HealthModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 08/05/2023.
//

import Foundation

struct HealthModel: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}
