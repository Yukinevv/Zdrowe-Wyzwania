//
//  HealthExerciseTimeViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 04/10/2023.
//

import Foundation
import HealthKit

class HealthExerciseTimeViewModel {
    var healthStore: HKHealthStore?

    var workoutType = HKObjectType.workoutType()

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let healthStore = healthStore else { return completion(false) }

        healthStore.requestAuthorization(toShare: [], read: [workoutType]) { success, _ in
            completion(success)
        }
    }

    func requestExerciseTime() -> [HealthModel] {
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .greaterThan, duration: 30)

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        var data: [HealthModel] = []

        let query = HKSampleQuery(sampleType: workoutType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in

            if let workoutSamples = samples as? [HKWorkout] {
                for workout in workoutSamples {
                    let duration = workout.duration
                    let durationMinutes = duration / 60.0

                    data.append(.init(count: Int(durationMinutes), date: workout.startDate))
                }
            }
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }

        return data
    }

    func requestExerciseTimeFromLastWeek() -> [HealthModel] {
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())

        let workoutPredicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: Date(), options: .strictStartDate)

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        var data: [HealthModel] = []

        let query = HKSampleQuery(sampleType: workoutType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in

            if let workoutSamples = samples as? [HKWorkout] {
                for workout in workoutSamples {
                    let duration = workout.duration
                    let durationMinutes = duration / 60.0

                    print("czas treningu \(durationMinutes)")

                    data.append(.init(count: Int(durationMinutes), date: workout.startDate))
                }
            }
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }

        return data
    }
}
