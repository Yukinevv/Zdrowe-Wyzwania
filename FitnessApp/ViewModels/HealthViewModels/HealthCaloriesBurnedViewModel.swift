//
//  HealthCaloriesBurnedViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 19/10/2023.
//

import Foundation
import HealthKit

class HealthCaloriesBurnedViewModel {
    var healthStore: HKHealthStore

    var caloriesBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!

    var startOfDay = Calendar.current.startOfDay(for: Date())

    var caloriesBurned: Double = 0.0
    var caloriesBurnedArray: [Double] = []

    init() {
        healthStore = HKHealthStore()
        let readTypes = Set([caloriesBurnedType])

        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: readTypes)
                requestCaloriesBurned()
                requestHighestCaloriesBurnedFromLastWeek()
            } catch {
                print("Blad przy probie pobrania danych zdrowotnych")
            }
        }
    }

    /// Pobiera ilosc spalonych kalorii z dzisiejszego dnia z bazy danych zdrowotnych HealthKir, wykonuje odpowiedni request
    func requestCaloriesBurned() {
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: caloriesBurnedType, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Blad przy pobraniu danych dotyczacych dzisiaj spalonych kalorii")
                return
            }

            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())

            DispatchQueue.main.async {
                self.caloriesBurned = caloriesBurned
            }
        }
        healthStore.execute(query)
    }

    /// Pobiera najwyzsze wartosci przebytych krokow z ostatniego tygodnia z bazy danych zdrowotnych HealthKit, wykonuje odpowiedni request
    func requestHighestCaloriesBurnedFromLastWeek() {
        let interval = DateComponents(day: 1)
        let anchorDate = Calendar.current.startOfDay(for: .weekAgo)

        let query = HKStatisticsCollectionQuery(quantityType: caloriesBurnedType, quantitySamplePredicate: nil, anchorDate: anchorDate, intervalComponents: interval)

        query.initialResultsHandler = { _, result, error in
            guard let result = result, error == nil else {
                print("Blad przy pobraniu danych dotyczacych spalonych kalorii z ostatniego tygodnia")
                return
            }
            var caloriesBurnedData = [Double]()

            result.enumerateStatistics(from: .weekAgo, to: Date()) { statistics, _ in
                caloriesBurnedData.append(statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0.00)
            }

            DispatchQueue.main.async {
                self.caloriesBurnedArray = Array(caloriesBurnedData.sorted(by: >).prefix(3))
            }
        }
        healthStore.execute(query)
    }
}
