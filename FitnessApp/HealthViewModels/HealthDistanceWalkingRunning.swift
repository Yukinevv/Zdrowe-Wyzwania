//
//  HealthDistanceWalkingRunning.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 19/06/2023.
//

import Foundation
import HealthKit

class HealthDistanceWalkingRunning: ObservableObject {
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
        var distanceWalkingRunning: [HealthModel] = []

        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in

            let count = statistics.sumQuantity()?.doubleValue(for: .mile())

            let distance = HealthModel(count: Int(count ?? 0), date: statistics.startDate)
            distanceWalkingRunning.append(distance)
        }
        return distanceWalkingRunning
    }

    func requestDistanceWalkingRunning(completion: @escaping (HKStatisticsCollection?) -> Void) {
        let distanceType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!

        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())

        let anchorDate = Date.mondayAt12AM()

        let daily = DateComponents(day: 1)

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        query = HKStatisticsCollectionQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)

        query!.initialResultsHandler = { _, statisticsCollection, _ in
            completion(statisticsCollection)
        }

        if let healthStore = healthStore, let query = query {
            healthStore.execute(query)
        }
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let calorieType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!

        guard let healthStore = healthStore else { return completion(false) }

        healthStore.requestAuthorization(toShare: [], read: [calorieType]) { success, _ in
            completion(success)
        }
    }
}
