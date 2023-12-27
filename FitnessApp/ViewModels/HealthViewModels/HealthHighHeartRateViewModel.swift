//
//  HealthHighHeartRatrViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 21/10/2023.
//

import HealthKit
import SwiftUI

class HealthHighHeartRateViewModel {
    var healthStore: HKHealthStore?

    var heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let healthStore = healthStore else { return completion(false) }

        healthStore.requestAuthorization(toShare: [], read: [heartRateType]) { success, _ in
            completion(success)
        }
    }

    func requestHighHeartRateData(completion: @escaping ([HKQuantitySample]) -> Void) {
        @AppStorage("heartRateGoal") var heartRateGoal: String = ""

        var highHeartRateSamples: [HKQuantitySample] = []

        let predicate = HKQuery.predicateForSamples(withStart: .dayAgo, end: Date())
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKQuantitySample], error == nil else {
                print("Blad przy pobieraniu danych o wysokim tetnie")
                return
            }

            highHeartRateSamples = samples.filter { sample in
                sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) > Double(heartRateGoal) ?? 100
            }

            for data in highHeartRateSamples {
                print("Wysokie tetno: \(data.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())))")
            }

            completion(highHeartRateSamples)
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }
}
