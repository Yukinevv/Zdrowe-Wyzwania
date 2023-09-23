//
//  HealthStatsTest.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 04/06/2023.
//

import HealthKit
import SwiftUI

class HealthData {
    var healthStore: HKHealthStore?

    let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    let exerciseTimeType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
    let calorieType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
    let distanceWalkingRunningType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
    let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
    let workoutType = HKObjectType.workoutType()

    let startOfDay = Calendar.current.startOfDay(for: Date())

    var steps: Double = 0.0
    var exercise: Double = 0.0
    var exerciseTime: Double = 0.0
    var calories: Double = 0.0
    var distanceWalkingRunning: Double = 0.0
    var highHeartRate: Double = 0.0
    var sleepTime: String = ""

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }

        requestAuth()

        requestStepCount()
        requestCaloriesBurned()
        requestExerciseTime()
        requestExerciseTime2()
        requestDistanceWalkingRunning()
        requestHighHeartRate()
    }

    func requestAuth() {
        let shareTypes = Set([HKObjectType.workoutType(), stepType, calorieType, sleepType])
        let readTypes = Set([HKObjectType.workoutType(), stepType, calorieType, exerciseTimeType, sleepType, distanceWalkingRunningType, heartRateType, workoutType])

        if let healthStore = healthStore {
            healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { sucess, error in
                if let error = error {
                    print("Nie zautoryzowano do uzycia Healthkita: \(error)")
                } else if sucess {
                    print("Przydzielono dostep do danych z Healthkita")
                }
            }
        }
    }

    func requestStepCount() {
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in

            if let result = result, let sum = result.sumQuantity() {
                let stepCount = sum.doubleValue(for: HKUnit.count())
                print("Liczba kroków z dzisiaj: \(stepCount)")

                self.steps = stepCount
            } else {
                if let error = error {
                    print("Wystąpił błąd podczas pobierania liczby kroków z dzisiaj: \(error.localizedDescription)")
                }
            }
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }

    func requestExerciseTime() {
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: exerciseTimeType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let result = result, let sum = result.sumQuantity() {
                let exerciseTime = sum.doubleValue(for: HKUnit.hour())
                print("Czas aktywności z dzisiaj (w godziach): \(exerciseTime)")

                self.exercise = exerciseTime
            } else {
                if let error = error {
                    print("Wystąpił błąd podczas pobierania czasu aktywności z dzisiaj: \(error.localizedDescription)")
                }
            }
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }

    func requestExerciseTime2() {
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .greaterThan, duration: 30)

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: workoutType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in

            if let workoutSamples = samples as? [HKWorkout] {
                for workout in workoutSamples {
                    let duration = workout.duration
                    let durationMinutes = duration / 60.0
                    print("Czas treningu w minutach: \(durationMinutes)")

                    self.exerciseTime = durationMinutes
                }
            }
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }

    func requestCaloriesBurned() {
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let result = result, let sum = result.sumQuantity() {
                let activeEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
                print("Ilość spalonych kalorii z dzisiaj: \(activeEnergy)")

                self.calories = activeEnergy
            } else {
                if let error = error {
                    print("Wystąpił błąd podczas pobierania ilości spalonych kalorii z dzisiaj: \(error.localizedDescription)")
                }
            }
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }

    func requestDistanceWalkingRunning() {
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: distanceWalkingRunningType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let result = result, let sum = result.sumQuantity() {
                let distance = sum.doubleValue(for: HKUnit.mile())
                print("Przebyty dystansa (w milach): \(distance)")

                self.distanceWalkingRunning = distance
            } else {
                if let error = error {
                    print("Wystąpił błąd podczas pobierania przebytego dystansu: \(error.localizedDescription)")
                }
            }
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }

    func requestHighHeartRate() {
        let predicate = HKQuery.predicateForQuantitySamples(with: .greaterThan, quantity: HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 120))

        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
            guard let heartRateSamples = samples as? [HKQuantitySample] else {
                return
            }

            self.highHeartRate = heartRateSamples.last?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 1.0
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }

    func requestSleepTime() {
        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in

            // DispatchQueue.main.async {
            if let error = error {
                print("Wystąpił błąd podczas pobierania danych o snie: \(error.localizedDescription)")
                return
            }

            /* if let sleepSamples = samples as? [HKCategorySample] {
                 for sleepSample in sleepSamples {
                     print("Czas: \(sleepSample.startDate) - \(sleepSample.endDate)")

                     let components = Calendar.current.dateComponents([.hour, .minute, .second], from: sleepSample.startDate, to: sleepSample.endDate)

                     var timeComponents = DateComponents()
                     timeComponents.hour = components.hour!
                     timeComponents.minute = components.minute!
                     timeComponents.second = components.second!

                     let timeOnly = Calendar.current.date(from: timeComponents)!

                     let dateFormatter = DateFormatter()
                     dateFormatter.dateFormat = "HH:mm:ss"

                     let formattedTime = dateFormatter.string(from: timeOnly)

                     print("Czas snu: \(formattedTime)")

                     self.sleepTime = formattedTime
                 }
             } */

            if let sleepSample = samples?.last as? HKCategorySample {
                print("Czas: \(sleepSample.startDate) - \(sleepSample.endDate)")

                let components = Calendar.current.dateComponents([.hour, .minute, .second], from: sleepSample.startDate, to: sleepSample.endDate)

                var timeComponents = DateComponents()
                timeComponents.hour = components.hour!
                timeComponents.minute = components.minute!
                timeComponents.second = components.second!

                let timeOnly = Calendar.current.date(from: timeComponents)!

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"

                let formattedTime = dateFormatter.string(from: timeOnly)

                print("Czas snu: \(formattedTime)")

                self.sleepTime = formattedTime
            }
            // }
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }

        Thread.sleep(forTimeInterval: 0.5)
    }
}
