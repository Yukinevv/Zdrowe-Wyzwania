//
//  HealthWorkoutViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 14/10/2023.
//

import HealthKit
import SwiftUI

class HealthWorkoutViewModel: ObservableObject {
    let healthStore = HKHealthStore()

    @Published var activites: [String: WorkoutModel] = [:]

    @Published var mockActivities: [String: WorkoutModel] = [
        "todaySteps": WorkoutModel(id: 0, title: "Kroki", subtitle: "Cel 10,000", image: "figure.walk", tintColor: .green, amount: "8,429"),
        "todayCalories": WorkoutModel(id: 1, title: "Kalorie", subtitle: "Cel 500", image: "flame", tintColor: .red, amount: "360 kcal"),
        "weekRunning": WorkoutModel(id: 2, title: "Bieganie", subtitle: "Obecny tydzień", image: "figure.walk", tintColor: .green, amount: "60 minut"),
        "weekLifting": WorkoutModel(id: 3, title: "Siłownia", subtitle: "Obecny tydzień", image: "dumbbell", tintColor: .cyan, amount: "80 minut"),
        "weekSoccer": WorkoutModel(id: 4, title: "Piłka nozna", subtitle: "Obecny tydzień", image: "figure.soccer", tintColor: .blue, amount: "20 minut"),
        "weekBasketball": WorkoutModel(id: 5, title: "Koszykówka", subtitle: "Obecny tydzień", image: "figure.basketball", tintColor: .orange, amount: "18 minut"),
        "weekStairs": WorkoutModel(id: 6, title: "Stair Stepper", subtitle: "Obecny tydzień", image: "figure.stair.stepper", tintColor: .green, amount: "10 minut"),
        "weekKickbox": WorkoutModel(id: 7, title: "Kickboxing", subtitle: "Obecny tydzień", image: "figure.kickboxing", tintColor: .green, amount: "25 minut"),
    ]

    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        let healthTypes: Set = [steps, calories, workout]

        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchCurrentWeekWorkoutStats()
            } catch {
                print("errror fetching health data")
            }
        }
    }

    func fetchCurrentWeekWorkoutStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workout, predicate: timePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("error fetching week running data")
                return
            }

            var runningCount: Int = 0
            var strengthCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairsCount: Int = 0
            var kickboxingCount: Int = 0
            for workout in workouts {
                if workout.workoutActivityType == .running {
                    let duration = Int(workout.duration) / 60
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    let duration = Int(workout.duration) / 60
                    strengthCount += duration
                } else if workout.workoutActivityType == .soccer {
                    let duration = Int(workout.duration) / 60
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    let duration = Int(workout.duration) / 60
                    basketballCount += duration
                } else if workout.workoutActivityType == .stairClimbing {
                    let duration = Int(workout.duration) / 60
                    stairsCount += duration
                } else if workout.workoutActivityType == .kickboxing {
                    let duration = Int(workout.duration) / 60
                    kickboxingCount += duration
                }
            }

            let runningActivity = WorkoutModel(id: 2, title: "Running", subtitle: "This week", image: "figure.walk", tintColor: .green, amount: "\(runningCount) minutes")
            let strengthActivity = WorkoutModel(id: 3, title: "Weight Lifting", subtitle: "This week", image: "dumbbell", tintColor: .cyan, amount: "\(strengthCount) minutes")
            let soccerActivity = WorkoutModel(id: 4, title: "Soccer", subtitle: "This week", image: "figure.soccer", tintColor: .blue, amount: "\(soccerCount) minutes")
            let basketballActivity = WorkoutModel(id: 5, title: "Basketball", subtitle: "This week", image: "figure.basketball", tintColor: .orange, amount: "\(basketballCount) minutes")
            let stairActivity = WorkoutModel(id: 6, title: "Stair Stepper", subtitle: "This week", image: "figure.stair.stepper", tintColor: .green, amount: "\(stairsCount) minutes")
            let kickboxActivity = WorkoutModel(id: 7, title: "Kickboxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "\(kickboxingCount) minutes")

            DispatchQueue.main.async {
                self.activites["weekRunning"] = runningActivity
                self.activites["weekStrength"] = strengthActivity
                self.activites["weekSoccer"] = soccerActivity
                self.activites["weekBasketball"] = basketballActivity
                self.activites["weekStairs"] = stairActivity
                self.activites["weekKickbox"] = kickboxActivity
            }
        }
        healthStore.execute(query)
    }
}
