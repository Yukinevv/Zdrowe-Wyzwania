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
                requestStepCount { data, error in
                    if let error = error {
                        print("Wystąpił błąd: \(error)")
                    } else if let data = data {
                        self.stepCount = data
                    } else {
                        print("Brak danych o ilości przebytych kroków")
                    }
                }
                requestCaloriesBurned { data, error in
                    if let error = error {
                        print("Wystąpił błąd: \(error)")
                    } else if let data = data {
                        self.caloriesBurned = data
                    } else {
                        print("Brak danych o spalonych kaloriach")
                    }
                }
                requestSleepData { data, error in
                    if let error = error {
                        print("Wystąpił błąd: \(error)")
                    } else if let data = data {
                        self.sleepData = data
                    } else {
                        print("Brak danych o czasie snu")
                    }
                }
                requestWaterData { data, error in
                    if let error = error {
                        print("Wystąpił błąd: \(error)")
                    } else if let data = data {
                        self.waterAmount = data
                    } else {
                        print("Brak danych o nawodnieniu")
                    }
                }
                requestHighHeartRateData { data, error in
                    if let error = error {
                        print("Wystąpił błąd: \(error)")
                    } else if let data = data {
                        self.highHeartRateValue = data
                    } else {
                        print("Brak danych o wysokim tętnie")
                    }
                }
                requestWorkoutTimeData { data, error in
                    if let error = error {
                        print("Wystąpił błąd: \(error)")
                    } else if let data = data {
                        self.workoutTime = data
                    } else {
                        print("Brak danych o czasie treningów")
                    }
                }
            } catch {
                print("Błąd przy próbie pobrania danych zdrowotnych")
            }
        }
    }

    func formatTime(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: timeInterval) ?? ""
    }

    /// Pobiera ilosc przebytych krokow z dzisiejszego dnia z bazy danych zdrowotnych HealthKit, wykonuje odpowiedni request,
    /// zawiera obsluge bledow w tym przypadek braku wybranych danych
    ///
    /// - Parameters:
    ///   - completion: Metoda wywolywana z roznymi parametrami w zaleznosci od powodzenia zapytania
    func requestStepCount(completion: @escaping (Double?, Error?) -> Void) {
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

    /// Pobiera ilosc spalonych kalorii z dzisiejszego dnia z bazy danych zdrowotnych HealthKit, wykonuje odpowiedni request
    ///
    /// - Parameters:
    ///   - completion: Metoda wywolywana z roznymi parametrami w zaleznosci od powodzenia zapytania
    func requestCaloriesBurned(completion: @escaping (Double?, Error?) -> Void) {
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

    /// Pobiera czas snu z dzisiejszego dnia z bazy danych zdrowotnych HealthKit, wykonuje odpowiedni request
    ///
    /// - Parameters:
    ///   - completion: Metoda wywolywana z roznymi parametrami w zaleznosci od powodzenia zapytania
    func requestSleepData(completion: @escaping (Double?, Error?) -> Void) {
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())

        let query = HKSampleQuery(sampleType: sleepDataType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            if let error = error {
                print("Błąd przy pobieraniu danych dotyczących dzisiejszego czasu snu: \(error)")
                completion(nil, error)
                return
            }

            guard let samples = samples else {
                print("Brak danych dotyczących dzisiejszego czasu snu")
                completion(nil, nil)
                return
            }

            var sleepTime: Double = 0.0

            if let sample = samples.last {
                sleepTime = sample.endDate.timeIntervalSince(sample.startDate)
            }

            let totalSleepTimeInHours = sleepTime / 3600.0
            completion(totalSleepTimeInHours, nil)
        }
        healthStore.execute(query)
    }

    /// Pobiera informacje o nawodnieniu z dzisiejszego dnia z bazy danych zdrowotnych HealthKit, wykonuje odpowiedni request
    ///
    /// - Parameters:
    ///   - completion: Metoda wywolywana z roznymi parametrami w zaleznosci od powodzenia zapytania
    func requestWaterData(completion: @escaping (Double?, Error?) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: waterType, quantitySamplePredicate: predicate) { _, result, error in
            if let error = error {
                print("Błąd przy pobieraniu danych dotyczących dzisiejszego nawodnienia: \(error)")
                completion(nil, error)
                return
            }

            guard let quantity = result?.sumQuantity() else {
                print("Brak danych dotyczących dzisiejszego nawodnienia")
                completion(nil, nil)
                return
            }

            let waterAmount = quantity.doubleValue(for: HKUnit.literUnit(with: .milli))
            completion(waterAmount, nil)
        }
        healthStore.execute(query)
    }

    /// Pobiera iformacje o wystapieniu wysokiego tetna z dzisiejszego dnia z bazy danych zdrowotnych HealthKit, wykonuje odpowiedni request
    ///
    /// - Parameters:
    ///   - completion: Metoda wywolywana z roznymi parametrami w zaleznosci od powodzenia zapytania
    func requestHighHeartRateData(completion: @escaping (Double?, Error?) -> Void) {
        @AppStorage("heartRateGoal") var heartRateGoal: String = ""

        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            if let error = error {
                print("Błąd przy pobieraniu danych dotyczących wystąpienia wysokiego tętna z dzisiaj: \(error)")
                completion(nil, error)
                return
            }

            guard let samples = samples as? [HKQuantitySample] else {
                print("Brak danych dotyczących wysokiego tętna")
                completion(nil, nil)
                return
            }

            let highHeartRateSamples = samples.filter { sample in
                sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) > Double(heartRateGoal) ?? 100
            }

            completion(highHeartRateSamples.last?.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) ?? 0, nil)
        }
        healthStore.execute(query)
    }

    /// Pobiera czas treningu z dzisiejszego dnia z bazy danych zdrowotnych HealthKit, wykonuje odpowiedni request
    ///
    /// - Parameters:
    ///   - completion: Metoda wywolywana z roznymi parametrami w zaleznosci od powodzenia zapytania
    func requestWorkoutTimeData(completion: @escaping (Double?, Error?) -> Void) {
        let workoutType = HKWorkoutType.workoutType()

        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            if let error = error {
                print("Błąd przy pobieraniu danych dotyczących dzisiejszego czasu treningów: \(error)")
                completion(nil, error)
                return
            }

            guard let samples = samples as? [HKWorkout] else {
                print("Brak danych dotyczących dzisiejszego czasu treningów")
                completion(nil, nil)
                return
            }

            let workoutTime = samples.last?.duration
            let totalWorkoutTimeInHours = (workoutTime ?? 0.0) / 3600.0
            completion(totalWorkoutTimeInHours, nil)
        }
        healthStore.execute(query)
    }
}
