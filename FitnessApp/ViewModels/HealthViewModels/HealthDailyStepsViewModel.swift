//
//  HealthDailyStepsViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 14/10/2023.
//

import Foundation
import HealthKit
import SwiftUI

struct DailyStepView: Identifiable {
    let id = UUID()
    let date: Date
    let stepCount: Double
}

class HealthDailyStepsViewModel: ObservableObject {
    let healthStore = HKHealthStore()

    @Published var oneWeekChartData = [DailyStepView]()
    @Published var oneMonthChartData = [DailyStepView]()
    @Published var threeMonthChartData = [DailyStepView]()
    @Published var yearToDateChartData = [DailyStepView]()
    @Published var oneYearChartData = [DailyStepView]()

    init() {
        let steps = HKQuantityType(.stepCount)
        let healthTypes: Set = [steps]

        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchPastMonthStepData()
            } catch {
                print("error fetching health data")
            }
        }
    }

    func fetchDailySteps(startDate: Date, completion: @escaping ([DailyStepView]) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)

        let anchorDate = Calendar.current.startOfDay(for: startDate)
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: anchorDate, intervalComponents: interval)

        query.initialResultsHandler = { _, result, error in
            guard let result = result, error == nil else {
                completion([])
                return
            }
            var dailySteps = [DailyStepView]()

            result.enumerateStatistics(from: startDate, to: Date()) { statistics, _ in
                dailySteps.append(DailyStepView(date: statistics.startDate, stepCount: statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.00))
            }
            completion(dailySteps)
        }
        healthStore.execute(query)
    }
}

extension HealthDailyStepsViewModel {
    func fetchPastWeekStepData() {
        fetchDailySteps(startDate: .oneWeekAgo) { dailySteps in
            DispatchQueue.main.async {
                self.oneWeekChartData = dailySteps
            }
        }
    }

    func fetchPastMonthStepData() {
        fetchDailySteps(startDate: .oneMonthAgo) { dailySteps in
            DispatchQueue.main.async {
                self.oneMonthChartData = dailySteps
            }
        }
    }

    func fetchPastThreeMonthsStepData() {
        fetchDailySteps(startDate: .threeMonthsAgo) { dailySteps in
            DispatchQueue.main.async {
                self.threeMonthChartData = dailySteps
            }
        }
    }

    func fetchYearToDateStepData() {
        fetchDailySteps(startDate: .yearToDate) { dailySteps in
            DispatchQueue.main.async {
                self.yearToDateChartData = dailySteps
            }
        }
    }

    func fetchPastYearStepData() {
        fetchDailySteps(startDate: .oneYearAgo) { dailySteps in
            DispatchQueue.main.async {
                self.oneYearChartData = dailySteps
            }
        }
    }
}
