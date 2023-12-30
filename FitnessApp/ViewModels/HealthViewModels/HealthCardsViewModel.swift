//
//  HealthCardsViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 04/06/2023.
//

import HealthKit
import SwiftUI

class HealthCardsViewModel {
    var healthStore: HKHealthStore

    var stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    var caloriesBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    var sleepDataType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
    var waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
    var heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
    var workoutType = HKWorkoutType.workoutType()

    var startOfDay = Calendar.current.startOfDay(for: Date())

    var stepCount: Double = 0.0
    var caloriesBurned: Double = 0.0
    var sleepData: Double = 0.0
    var waterAmount: Double = 0.0
    var highHeartRateValue: Double = 0.0
    var workoutTime: Double = 0.0

    init() {
        healthStore = HKHealthStore()
        let readTypes = Set([stepCountType, caloriesBurnedType, sleepDataType, waterType, heartRateType, workoutType])

        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: readTypes)
                requestStepCount { data in
                    self.stepCount = data
                }
                requestCaloriesBurned { data in
                    self.caloriesBurned = data
                }
                requestSleepData { data in
                    self.sleepData = data
                }
                requestWaterData { data in
                    self.waterAmount = data
                }
                requestHighHeartRateData { data in
                    self.highHeartRateValue = data
                }
                requestWorkoutTimeData { data in
                    self.workoutTime = data
                }
            } catch {
                print("Blad przy probie pobrania danych zdrowotnych")
            }
        }
    }

    func formatTime(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: timeInterval) ?? ""
    }

    func requestStepCount(completion: @escaping (Double) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Blad przy pobraniu danych dotyczacych dzisiaj przebytych krokow")
                return
            }

            let stepCount = quantity.doubleValue(for: .count())

            completion(stepCount)
        }
        healthStore.execute(query)
    }

    func requestCaloriesBurned(completion: @escaping (Double) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: caloriesBurnedType, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Blad przy pobraniu danych dotyczacych dzisiaj spalonych kalorii")
                return
            }

            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())

//            DispatchQueue.main.async {
//                self.caloriesBurned = caloriesBurned
//            }

            completion(caloriesBurned)
        }
        healthStore.execute(query)
    }

    func requestSleepData(completion: @escaping (Double) -> Void) {
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date()) // .startOfDay

        let query = HKSampleQuery(sampleType: sleepDataType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples, error == nil else {
                print("Blad przy pobraniu danych dotyczacych dzisiejszego czasu snu")
                return
            }

//            var totalSleepTime: TimeInterval = 0
//
//            for sample in samples {
//                if let sample = sample as? HKCategorySample {
//                    totalSleepTime += sample.endDate.timeIntervalSince(sample.startDate)
//                }
//            }

            var sleepTime: Double = 0.0

            if let sample = samples.last {
                sleepTime = sample.endDate.timeIntervalSince(sample.startDate)
            }

            let totalSleepTimeInHours = sleepTime / 3600.0

//            DispatchQueue.main.async {
//                // self.sleepData = self.formatTime(totalSleepTime)
//                self.sleepData = totalSleepTimeInHours
//            }

            completion(totalSleepTimeInHours)
        }
        healthStore.execute(query)
    }

    func requestWaterData(completion: @escaping (Double) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: waterType, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Blad przy pobraniu danych dotyczacych dzisiejszego nawodnienia")
                return
            }

            let waterAmount = quantity.doubleValue(for: HKUnit.literUnit(with: .milli))

//            DispatchQueue.main.async {
//                self.waterAmount = waterAmount
//            }

            completion(waterAmount)
        }
        healthStore.execute(query)
    }

    func requestHighHeartRateData(completion: @escaping (Double) -> Void) {
        @AppStorage("heartRateGoal") var heartRateGoal: String = ""

        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKQuantitySample], error == nil else {
                print("Blad przy pobraniu danych dotyczacych wystapienia wysokiego tetna z dzisiaj")
                return
            }

            let highHeartRateSamples = samples.filter { sample in
                sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) > Double(heartRateGoal) ?? 100
            }

//            DispatchQueue.main.async {
//                // self.highHeartRateSamples = highHeartRateSamples
//                self.highHeartRateValue = highHeartRateSamples.last?.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 0
//            }

            completion(highHeartRateSamples.last?.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 0)
        }
        healthStore.execute(query)
    }

    func requestWorkoutTimeData(completion: @escaping (Double) -> Void) {
        let workoutType = HKWorkoutType.workoutType()

        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKWorkout], error == nil else {
                print("Blad przy pobraniu danych dotyczacych dzisiejszego czasu treningow")
                return
            }

            // let totalWorkoutTime = samples.reduce(0) { $0 + $1.duration }

            let workoutTime = samples.last?.duration

            let totalWorkoutTimeInHours = (workoutTime ?? 0.0) / 3600.0

//            DispatchQueue.main.async {
//                // self.workoutTime = self.formatTime(totalWorkoutTime)
//                self.workoutTime = totalWorkoutTimeInHours
//            }

            completion(totalWorkoutTimeInHours)
        }
        healthStore.execute(query)
    }
}
