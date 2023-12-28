//
//  HealthModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 08/05/2023.
//

import Foundation
import HealthKit

struct HealthModel: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
    let type: HKWorkoutActivityType?

    init(count: Int, date: Date) {
        self.count = count
        self.date = date
        self.type = nil
    }

    init(count: Int, date: Date, type: HKWorkoutActivityType?) {
        self.count = count
        self.date = date
        self.type = type
    }
}
