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

    @Published var oneWeekChartStaticData = [DailyStepView]()
    @Published var oneMonthChartStaticData = [DailyStepView]()
    @Published var threeMonthChartStaticData = [DailyStepView]()
    @Published var yearToDateChartStaticData = [DailyStepView]()
    @Published var oneYearChartStaticData = [DailyStepView]()

    init() {
        let steps = HKQuantityType(.stepCount)
        let healthTypes: Set = [steps]

        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchPastWeekStepData()
            } catch {
                print("Blad przy probie pobrania danych zdrowotnych")
            }
        }

        let calendar = Calendar.current
        let currentDate = StaticData.staticData.getCurrentYearMonthDay()
        let stepsData = StaticData.staticData.stepsData

        for i in 1 ... 7 {
            oneWeekChartStaticData.append(DailyStepView(date: calendar.date(from: DateComponents(year: currentDate.year, month: currentDate.month, day: currentDate.day - i, hour: 12, minute: 0, second: 0)) ?? Date(), stepCount: stepsData[i - 1]))
        }
        for i in 1 ... 31 {
            oneMonthChartStaticData.append(DailyStepView(date: calendar.date(from: DateComponents(year: currentDate.year, month: currentDate.month, day: currentDate.day - i, hour: 12, minute: 0, second: 0)) ?? Date(), stepCount: stepsData[i - 1]))
        }
        for i in 1 ... 90 {
            threeMonthChartStaticData.append(DailyStepView(date: calendar.date(from: DateComponents(year: currentDate.year, month: currentDate.month, day: currentDate.day - i, hour: 12, minute: 0, second: 0)) ?? Date(), stepCount: stepsData[i - 1]))
        }
        for i in 1 ... 180 {
            yearToDateChartStaticData.append(DailyStepView(date: calendar.date(from: DateComponents(year: currentDate.year, month: currentDate.month, day: currentDate.day - i, hour: 12, minute: 0, second: 0)) ?? Date(), stepCount: stepsData[i - 1]))
        }
        for i in 1 ... 365 {
            oneYearChartStaticData.append(DailyStepView(date: calendar.date(from: DateComponents(year: currentDate.year, month: currentDate.month, day: currentDate.day - i, hour: 12, minute: 0, second: 0)) ?? Date(), stepCount: stepsData[i - 1]))
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
