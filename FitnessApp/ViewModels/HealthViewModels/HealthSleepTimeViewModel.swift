//
//  HealthSleepTimeViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 22/10/2023.
//

import Foundation
import HealthKit

class HealthSleepTimeViewModel {
    var healthStore: HKHealthStore?

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let healthStore = healthStore else { return completion(false) }

        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return
        }

        healthStore.requestAuthorization(toShare: [], read: [sleepType]) { success, _ in
            completion(success)
        }
    }

    func requestSleepData(completion: @escaping ([HKSample]?, Error?) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!

        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .weekOfYear, value: -1, to: endDate)!

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)

        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 0, sortDescriptors: nil) { _, samples, error in
            if let error = error {
                completion(nil, error)
                return
            }

            completion(samples?.reversed(), nil)
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }
}
