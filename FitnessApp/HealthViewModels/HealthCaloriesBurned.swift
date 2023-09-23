//
//  HealthCaloriesBurned.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 18/06/2023.
//

import Foundation
import HealthKit

class HealthCaloriesBurned: ObservableObject {
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) -> [HealthModel] {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        var caloriesBurned: [HealthModel] = []

        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in

            let count = statistics.sumQuantity()?.doubleValue(for: .kilocalorie())

            let calories = HealthModel(count: Int(count ?? 0), date: statistics.startDate)
            caloriesBurned.append(calories)
        }
        return caloriesBurned
    }

    func requestCaloriesBurned(completion: @escaping (HKStatisticsCollection?) -> Void) {
        let calorieType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!

        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())

        let anchorDate = Date.mondayAt12AM()

        let daily = DateComponents(day: 1)

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        query = HKStatisticsCollectionQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)

        query!.initialResultsHandler = { _, statisticsCollection, _ in
            completion(statisticsCollection)
        }

        if let healthStore = healthStore, let query = query {
            healthStore.execute(query)
        }
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let calorieType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!

        guard let healthStore = healthStore else { return completion(false) }

        healthStore.requestAuthorization(toShare: [], read: [calorieType]) { success, _ in
            completion(success)
        }
    }
}
