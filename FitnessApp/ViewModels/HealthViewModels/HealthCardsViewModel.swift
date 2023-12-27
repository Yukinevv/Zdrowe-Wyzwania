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
                requestStepCount()
                requestCaloriesBurned()
                requestSleepData()
                requestWaterData()
                requestHighHeartRateData()
                requestWorkoutTimeData()
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

    func requestStepCount() {
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching todays step data")
                return
            }

            let stepCount = quantity.doubleValue(for: .count())

//            DispatchQueue.main.async {
//                self.stepCount = stepCount
//            }

            self.stepCount = stepCount
        }
        healthStore.execute(query)
    }

    func requestCaloriesBurned() {
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: caloriesBurnedType, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching todays calorie data")
                return
            }

            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())

//            DispatchQueue.main.async {
//                self.caloriesBurned = caloriesBurned
//            }
            self.caloriesBurned = caloriesBurned

            print("requestCaloriesBurned: \(self.caloriesBurned)")
        }
        healthStore.execute(query)
    }

    func requestSleepData() {
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date()) // .startOfDay

        let query = HKSampleQuery(sampleType: sleepDataType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples, error == nil else {
                print("Error fetching today's sleep data")
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

            self.sleepData = totalSleepTimeInHours
        }
        healthStore.execute(query)
    }

    func requestWaterData() {
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: waterType, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching today's water data")
                return
            }

            let waterAmount = quantity.doubleValue(for: HKUnit.literUnit(with: .milli))

//            DispatchQueue.main.async {
//                self.waterAmount = waterAmount
//            }

            self.waterAmount = waterAmount
        }
        healthStore.execute(query)
    }

    func requestHighHeartRateData() {
        @AppStorage("heartRateGoal") var heartRateGoal: String = ""

        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKQuantitySample], error == nil else {
                print("Error fetching high heart rate data")
                return
            }

            let highHeartRateSamples = samples.filter { sample in
                sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) > Double(heartRateGoal) ?? 100
            }

//            DispatchQueue.main.async {
//                // self.highHeartRateSamples = highHeartRateSamples
//                self.highHeartRateValue = highHeartRateSamples.last?.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 0
//            }

            self.highHeartRateValue = highHeartRateSamples.last?.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 0
        }
        healthStore.execute(query)
    }

    func requestWorkoutTimeData() {
        let workoutType = HKWorkoutType.workoutType()

        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKWorkout], error == nil else {
                print("Error fetching workout time data")
                return
            }

            // let totalWorkoutTime = samples.reduce(0) { $0 + $1.duration }

            let workoutTime = samples.last?.duration

            let totalWorkoutTimeInHours = (workoutTime ?? 0.0) / 3600.0

//            DispatchQueue.main.async {
//                // self.workoutTime = self.formatTime(totalWorkoutTime)
//                self.workoutTime = totalWorkoutTimeInHours
//            }

            self.workoutTime = totalWorkoutTimeInHours
        }
        healthStore.execute(query)
    }
}
