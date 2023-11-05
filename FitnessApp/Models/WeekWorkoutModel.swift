//
//  WeekWorkoutModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import HealthKit

struct WeekWorkoutModel {
    let workoutDays: [WorkoutDayModel]

    var summary: String {
        return "Wykonane w \(countWeekWorkoutDays(workoutDays)) z 7 ostatnich dni."
    }

    init(workouts: [HKWorkout]) {
        let today = Date()
        var workoutDays: [WorkoutDayModel] = []
        [0, 1, 2, 3, 4, 5, 6].forEach { e in
            let date = Calendar.current.date(byAdding: .day, value: -e, to: today)!
            let dateWorkouts = workouts.filter { Calendar.current.isDate($0.startDate, equalTo: date, toGranularity: .day) }
            workoutDays.append(WorkoutDayModel(date: date, workouts: dateWorkouts))
        }
        self.workoutDays = workoutDays.reversed()
    }

    private func countWeekWorkoutDays(_ workouts: [WorkoutDayModel]) -> Int {
        let myCalendar = Calendar(identifier: .gregorian)
        var days = [false, false, false, false, false, false, false]
        workouts.forEach { e in
            if e.workouts.count > 0 {
                let weekDay = myCalendar.component(.weekday, from: e.workouts[0].startDate) - 1
                days[weekDay] = true
            }
        }
        let trainingDays = days.filter { $0 }
        return trainingDays.count
    }
}

extension WeekWorkoutModel {
    static var data = WeekWorkoutModel(workouts: [
        generateWorkout(daysAgo: 6),
        generateWorkout(daysAgo: 6),
        generateWorkout(daysAgo: 4),
        generateWorkout(daysAgo: 3),
        generateWorkout(daysAgo: 1),
        generateWorkout(daysAgo: 1),
    ])

    private static func generateWorkout(daysAgo: Int) -> HKWorkout {
        let totalEnergyBurned = Double.random(in: 350 ..< 651)
        let today = Date()
        let start = Calendar.current.date(byAdding: .day, value: -daysAgo, to: today)!
        let end = Calendar.current.date(byAdding: .minute, value: 60, to: start)!
        let workout = HKWorkout(
            activityType: .traditionalStrengthTraining,
            start: start,
            end: end,
            duration: 60,
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: totalEnergyBurned),
            totalDistance: nil, device: nil, metadata: nil)
        return workout
    }
}
