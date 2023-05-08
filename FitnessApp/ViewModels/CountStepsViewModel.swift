//
//  CountStepsViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 08/05/2023.
//

import Foundation

import HealthKit

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

class CountStepsViewModel: ObservableObject {
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    @Published var steps: [Step] = [Step]()

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()

        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in

            let count = statistics.sumQuantity()?.doubleValue(for: .count())

            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            self.steps.append(step)
        }
    }

    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!

        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())

        let anchorDate = Date.mondayAt12AM()

        let daily = DateComponents(day: 1)

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)

        query!.initialResultsHandler = { _, statisticsCollection, _ in
            completion(statisticsCollection)
        }

        if let healthStore = healthStore, let query = query {
            healthStore.execute(query)
        }
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!

        guard let healthStore = healthStore else { return completion(false) }

        healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, _ in
            completion(success)
        }
    }
}
