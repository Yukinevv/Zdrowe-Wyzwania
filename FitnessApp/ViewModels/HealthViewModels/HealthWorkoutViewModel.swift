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

    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        let healthTypes: Set = [steps, calories, workout]

        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                if !StaticData.staticData.isTestData {
                    requestStepCount { data, _ in
                        if let data = data {
                            let steps = WorkoutModel(id: 0, title: "Kroki", subtitle: "Cel \(Int(StaticData.staticData.stepsGoalString) ?? 10000)", image: "figure.walk", tintColor: .green, amount: String(Int(data)))
                            DispatchQueue.main.async {
                                self.activites["totalSteps"] = steps
                            }
                        } else {
                            let steps = WorkoutModel(id: 0, title: "Kroki", subtitle: "Cel \(Int(StaticData.staticData.stepsGoalString) ?? 10000)", image: "figure.walk", tintColor: .green, amount: "0")
                            DispatchQueue.main.async {
                                self.activites["totalSteps"] = steps
                            }
                        }
                    }
                    requestCaloriesBurned { data, _ in
                        if let data = data {
                            let calories = WorkoutModel(id: 1, title: "Kalorie", subtitle: "Cel \(Int(StaticData.staticData.caloriesGoalString) ?? 500)", image: "flame", tintColor: .red, amount: String(Int(data)) + " kcal")
                            DispatchQueue.main.async {
                                self.activites["totalCalories"] = calories
                            }
                        } else {
                            let calories = WorkoutModel(id: 1, title: "Kalorie", subtitle: "Cel \(Int(StaticData.staticData.caloriesGoalString) ?? 500)", image: "flame", tintColor: .red, amount: "0 kcal")
                            DispatchQueue.main.async {
                                self.activites["totalCalories"] = calories
                            }
                        }
                    }
                    fetchCurrentWeekWorkoutStats()
                }
            } catch {
                print("Blad przy probie pobrania danych zdrowotnych")
            }
        }
    }

    func fetchCurrentWeekWorkoutStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workout, predicate: timePredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                print("Blad przy probie pobrania danych treningowych z ostatniego tygodnia")
                return
            }

            var runningCount: Int = 0
            var strengthCount: Int = 0
            var swimmingCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairsCount: Int = 0
            for workout in workouts {
                if workout.workoutActivityType == .running {
                    let duration = Int(workout.duration) / 60
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    let duration = Int(workout.duration) / 60
                    strengthCount += duration
                } else if workout.workoutActivityType == .swimming {
                    let duration = Int(workout.duration) / 60
                    swimmingCount += duration
                } else if workout.workoutActivityType == .soccer {
                    let duration = Int(workout.duration) / 60
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    let duration = Int(workout.duration) / 60
                    basketballCount += duration
                } else if workout.workoutActivityType == .stairClimbing {
                    let duration = Int(workout.duration) / 60
                    stairsCount += duration
                }
            }

            let runningActivity = WorkoutModel(id: 2, title: "Bieganie", subtitle: "Obecny tydzień", image: "figure.run", tintColor: .orange, amount: "\(runningCount) min")
            let strengthActivity = WorkoutModel(id: 3, title: "Trening siłowy", subtitle: "Obecny tydzień", image: "dumbbell", tintColor: .cyan, amount: "\(strengthCount) min")
            let swimmingActivity = WorkoutModel(id: 4, title: "Pływanie", subtitle: "Obecny tydzień", image: "figure.pool.swim", tintColor: .blue, amount: "\(swimmingCount) min")
            let soccerActivity = WorkoutModel(id: 5, title: "Piłka nożna", subtitle: "Obecny tydzień", image: "figure.soccer", tintColor: .green, amount: "\(soccerCount) min")
            let basketballActivity = WorkoutModel(id: 6, title: "Koszykówka", subtitle: "Obecny tydzień", image: "figure.basketball", tintColor: .orange, amount: "\(basketballCount) min")
            let stairActivity = WorkoutModel(id: 7, title: "Orbitrek", subtitle: "Obecny tydzień", image: "figure.stair.stepper", tintColor: .cyan, amount: "\(stairsCount) min")

            DispatchQueue.main.async {
                self.activites["weekRunning"] = runningActivity
                self.activites["weekStrength"] = strengthActivity
                self.activites["weekSwimming"] = swimmingActivity
                self.activites["weekSoccer"] = soccerActivity
                self.activites["weekBasketball"] = basketballActivity
                self.activites["weekStairs"] = stairActivity
            }
        }
        healthStore.execute(query)
    }

    func requestStepCount(completion: @escaping (Double?, Error?) -> Void) {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate) { _, result, error in
            if let error = error {
                print("Błąd przy pobieraniu danych dotyczących dzisiaj przebytych kroków: \(error)")
                completion(nil, error)
                return
            }

            guard let quantity = result?.sumQuantity() else {
                print("Brak danych dotyczących dzisiaj przebytych kroków")
                completion(nil, nil)
                return
            }

            let stepCount = quantity.doubleValue(for: .count())
            completion(stepCount, nil)
        }
        healthStore.execute(query)
    }

    func requestCaloriesBurned(completion: @escaping (Double?, Error?) -> Void) {
        let caloriesBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: caloriesBurnedType, quantitySamplePredicate: predicate) { _, result, error in
            if let error = error {
                print("Błąd przy pobieraniu danych dotyczących dzisiaj spalonych kalorii: \(error)")
                completion(nil, error)
                return
            }

            guard let quantity = result?.sumQuantity() else {
                print("Brak danych dotyczących dzisiaj spalonych kalorii")
                completion(nil, nil)
                return
            }

            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            completion(caloriesBurned, nil)
        }
        healthStore.execute(query)
    }
}
