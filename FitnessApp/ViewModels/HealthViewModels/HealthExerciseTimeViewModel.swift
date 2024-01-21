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

    func requestExerciseTime(completion: @escaping ([HealthModel]) -> Void) {
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .greaterThan, duration: 5)

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        var data: [HealthModel] = []

        let query = HKSampleQuery(sampleType: workoutType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in

            if let workoutSamples = samples as? [HKWorkout] {
                for workout in workoutSamples {
                    let duration = workout.duration
                    let durationMinutes = duration / 60.0
                    print("durationMinutes: \(durationMinutes)")

                    data.append(.init(count: Int(durationMinutes), date: workout.startDate))

                    if data.count == 7 {
                        break
                    }
                }
            }

            while data.count < 5 {
                data.append(HealthModel(count: 0, date: Date()))
            }

            completion(data)
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }

    func requestExerciseTimeFromLastWeek(completion: @escaping ([HealthModel]) -> Void) {
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())

        let workoutPredicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: Date(), options: .strictStartDate)

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: workoutType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            var data: [HealthModel] = []

            if let workoutSamples = samples as? [HKWorkout] {
                for workout in workoutSamples {
                    let durationMinutes = workout.duration / 60.0
                    print("durationMinutes: \(durationMinutes)")
                    data.append(HealthModel(count: Int(durationMinutes), date: workout.startDate, type: workout.workoutActivityType))
                }
            }

            while data.count < 5 {
                data.append(HealthModel(count: 0, date: Date()))
            }

            completion(data)
        }

        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }
}
