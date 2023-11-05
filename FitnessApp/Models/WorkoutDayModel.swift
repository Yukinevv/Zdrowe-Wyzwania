//
//  WorkoutDayModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import Foundation
import HealthKit

struct WorkoutDayModel: Identifiable {
    let id: UUID
    let date: Date
    let workouts: [HKWorkout]

    var day: String {
        return date.weekday()
    }

    var number: Int {
        return date.day()
    }

    var didWorkout: Bool {
        return workouts.count > 0
    }

    var isToday: Bool {
        return Calendar.current.isDateInToday(date)
    }

    init(date: Date, workouts: [HKWorkout]) {
        id = UUID()
        self.date = date
        self.workouts = workouts
    }
}
