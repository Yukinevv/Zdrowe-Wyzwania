//
//  Constants.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import SwiftUI

struct Constants {
    static let widgetMediumHeight: CGFloat = 169
    static let widgetLargeHeight: CGFloat = 376
}

class StaticData {
    static let staticData = StaticData()

    @AppStorage("stepsCardVisibility") var stepsCardVisibility: Bool = true
    @AppStorage("caloriesCardVisibility") var caloriesCardVisibility: Bool = true
    @AppStorage("sleepCardVisibility") var sleepCardVisibility: Bool = true
    @AppStorage("waterCardVisibility") var waterCardVisibility: Bool = true
    @AppStorage("heartRateCardVisibility") var heartRateCardVisibility: Bool = true
    @AppStorage("workoutTimeCardVisibility") var workoutTimeCardVisibility: Bool = true
    @AppStorage("isTestData") var isTestData: Bool = true

    @AppStorage("stepsGoal") var stepsGoalString: String = ""
    @AppStorage("caloriesGoal") var caloriesGoalString: String = ""
    @AppStorage("sleepGoal") var sleepGoalString: String = ""
    @AppStorage("waterGoal") var waterGoalString: String = ""
    @AppStorage("heartRateGoal") var heartRateGoalString: String = ""
    @AppStorage("workoutTimeGoal") var workoutTimeGoalString: String = ""

    var stepsGoal: Double = 10000
    var caloriesGoal: Double = 500
    var sleepGoal: Double = 8
    var waterGoal: Double = 5
    var heartRateGoal: Double = 100
    var workoutTimeGoal: Double = 30

    var stepsData: [Double] = []
    var caloriesData: [Double] = []
    var sleepData: [Double] = []
    var waterData: [Double] = []
    var heartRateData: [Double] = []
    var workoutTimeData: [Double] = []

    private init() {
        stepsGoal = Double(stepsGoalString) ?? stepsGoal
        caloriesGoal = Double(caloriesGoalString) ?? caloriesGoal
        sleepGoal = Double(sleepGoalString) ?? sleepGoal
        waterGoal = Double(waterGoalString) ?? waterGoal
        heartRateGoal = Double(heartRateGoalString) ?? heartRateGoal
        workoutTimeGoal = Double(workoutTimeGoalString) ?? workoutTimeGoal

        for _ in 1 ... 366 {
            stepsData.append(Double(generateRandomNumber(min: 500, max: UInt32(stepsGoal))))
        }

        for _ in 1 ... 7 {
            caloriesData.append(Double(generateRandomNumber(min: 50, max: UInt32(caloriesGoal + 300))))
            sleepData.append(Double(generateRandomNumber(min: 3, max: UInt32(sleepGoal))))
            waterData.append(Double(generateRandomNumber(min: 1, max: UInt32(waterGoal))))
            heartRateData.append(Double(generateRandomNumber(min: 60, max: UInt32(heartRateGoal + 30))))
            workoutTimeData.append(Double(generateRandomNumber(min: 4, max: 15)) / 10.0)
        }
    }

    func getCurrentYearMonthDay() -> (year: Int, month: Int, day: Int) {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)

        guard let year = components.year, let month = components.month, let day = components.day else {
            fatalError("Blad w pobraniu dzisiejszej daty")
        }
        return (year, month, day)
    }

    func generateRandomNumber(min: UInt32, max: UInt32) -> UInt32 {
        guard min < max else {
            fatalError("min musi byc mniejsze od max")
        }
        return arc4random_uniform(max - min) + min
    }

    func getNthHighestValuesFromArray(arr: [Double], n: Int) -> [Double] {
        return Array(arr.sorted(by: >).prefix(n))
    }
}
