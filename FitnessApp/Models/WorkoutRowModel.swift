//
//  WorkoutRowModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import HealthKit

struct WorkoutRowModel {
    let workout: HKWorkout

    var activityName: String {
        return workout.workoutActivityType.name
    }

    var distance: String {
        return workout.totalDistance != nil ? String(format: "%0.2f", workout.totalDistance!.doubleValue(for: HKUnit.meter()) / 1000) : "-"
    }

    var durationHours: Int {
        return Int(floor(workout.duration / 3600))
    }

    var durationMinutes: Int {
        return Int(floor(workout.duration.truncatingRemainder(dividingBy: 3600)) / 60)
    }

    var energyBurned: String {
        return workout.totalEnergyBurned != nil ? String(format: "%0.f", workout.totalEnergyBurned!.doubleValue(for: HKUnit.kilocalorie())) : "-"
    }

    var imageName: String {
        return workout.workoutActivityType.associatedImageName
    }

    var imageSystemName: String {
        return workout.workoutActivityType.associatedImageSystemName
    }
}
