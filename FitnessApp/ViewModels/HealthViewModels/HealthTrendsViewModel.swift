//
//  HealthTrendsViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import Foundation
import HealthKit

class HealthTrendsViewModel: NSObject, ObservableObject {
    @Published var weekWorkoutModel = WeekWorkoutModel(workouts: [])
    @Published var recentWorkouts: [HKWorkout] = []

    private var healthStore: HKHealthStore?

    init(
        weekWorkoutModel: WeekWorkoutModel = WeekWorkoutModel(workouts: []),
        recentWorkouts: [HKWorkout] = []
    ) {
        self.weekWorkoutModel = weekWorkoutModel
        self.recentWorkouts = recentWorkouts

        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    func requestAuthorization(onSuccess: @escaping () -> Void, onError: @escaping (Error?) -> Void) {
        if HKHealthStore.isHealthDataAvailable() {
            let typesToRead: Set = [
                HKObjectType.workoutType(),
                HKQuantityType.quantityType(forIdentifier: .heartRate)!,
                HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            ]
            healthStore?.requestAuthorization(toShare: nil, read: typesToRead) { result, error in
                if let error = error {
                    onError(error)
                    return
                }
                guard result else {
                    onError(nil)
                    return
                }
                onSuccess()
            }
        }
    }

    func loadWorkoutData() {
        latestWorkoutWeekDays { data in
            self.weekWorkoutModel = data
        }
    }

    func latestWorkoutWeekDays(completion: ((WeekWorkoutModel) -> Void)?) {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -7, to: end)!

        let workoutPredicate = HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, duration: 1)

        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])

        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [workoutPredicate, datePredicate])

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: compound,
            limit: 0,
            sortDescriptors: [sortDescriptor]) { _, samples, error in
                DispatchQueue.main.async {
                    guard let samples = samples as? [HKWorkout], error == nil else {
                        let result = WeekWorkoutModel(workouts: [])
                        self.weekWorkoutModel = result
                        completion?(result)
                        return
                    }
                    let result = WeekWorkoutModel(workouts: samples)
                    self.weekWorkoutModel = result
                    completion?(result)
                }
            }

        healthStore?.execute(query)
    }

    func latestWorkouts(completion: @escaping (([HKWorkout]) -> Void)) {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -30, to: end)!

        let workoutPredicate = HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, duration: 1)

        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])

        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [workoutPredicate, datePredicate])

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: compound,
            limit: 0,
            sortDescriptors: [sortDescriptor]) { _, samples, error in
                DispatchQueue.main.async {
                    guard let samples = samples as? [HKWorkout], error == nil else {
                        self.recentWorkouts = []
                        completion([])
                        return
                    }
                    self.recentWorkouts = samples
                    completion(samples)
                }
            }

        healthStore?.execute(query)
    }
}
