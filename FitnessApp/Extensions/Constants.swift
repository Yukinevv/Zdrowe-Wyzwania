//
//  Constants.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import HealthKit
import SwiftUI

struct Constants {
    static let widgetMediumHeight: CGFloat = 170
    static let widgetLargeHeight: CGFloat = 380
}

class StaticData {
    static let staticData = StaticData()

    @AppStorage("isDarkMode") var isDarkMode: Bool = true

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
    var sleepData: [(date: Date, startTime: Date, endTime: Date, duration: TimeInterval)] = []
    var waterData: [Double] = []
    var heartRateData: [(date: Date, startTime: Date, endTime: Date, highHeartRate: Int)] = []
    var workoutTimeData: [Double] = []
    var workoutStaticData: [Daily] = []

    var recentWorkoutsData: [HKWorkout] = []
    var todayWorkouts: [HKWorkout] = []
    var weekWorkouts: [HKWorkout] = []
    var monthWorkouts: [HKWorkout] = []

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

        let calendar = Calendar.current
        let currentDate = getCurrentYearMonthDay()

        for i in 1 ... 7 {
            caloriesData.append(Double(generateRandomNumber(min: 50, max: UInt32(caloriesGoal + 300))))
            waterData.append(Double.random(in: 1 ... waterGoal))

            var tmpWorkoutTimeData = 0.0
            repeat {
                tmpWorkoutTimeData = Double(generateRandomNumber(min: 3, max: 12)) / 10.0
            } while workoutTimeData.contains(tmpWorkoutTimeData)
            workoutTimeData.append(tmpWorkoutTimeData)

            workoutStaticData.append(Daily(id: i - 1, day: (calendar.date(from: DateComponents(year: currentDate.year, month: currentDate.month, day: currentDate.day - i + 1, hour: 12, minute: 0, second: 0)) ?? Date()).weekday(), workout_In_Min: workoutTimeData[i - 1] * 60))
        }

        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: -6, to: startDate)!
        sleepData = generateSleepData(startDate: startDate, endDate: endDate)
        heartRateData = generateHighHeartRateData(startDate: startDate, endDate: endDate)

        for _ in 1 ... 25 {
            recentWorkoutsData.append(HKWorkout.generateWorkoutWithActivity(daysAgo: Int.random(in: 0 ... 40), activityType: HKWorkout.getActivityType(for: Int.random(in: 1 ... 74))!))
        }

        let oneDayInSeconds: TimeInterval = 24 * 60 * 60
        let weekInSeconds: TimeInterval = 7 * 24 * 60 * 60
        let monthInSeconds: TimeInterval = 30 * 24 * 60 * 60
        let today = Date()

        todayWorkouts = recentWorkoutsData.filter { workout in
            let timeDifference = today.timeIntervalSince(workout.startDate)
            return timeDifference <= oneDayInSeconds
        }
        weekWorkouts = recentWorkoutsData.filter { workout in
            let timeDifference = today.timeIntervalSince(workout.startDate)
            return timeDifference <= weekInSeconds
        }
        monthWorkouts = recentWorkoutsData.filter { workout in
            let timeDifference = today.timeIntervalSince(workout.startDate)
            return timeDifference <= monthInSeconds
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

    func generateSleepData(startDate: Date, endDate: Date) -> [(date: Date, startTime: Date, endTime: Date, duration: TimeInterval)] {
        var currentDate = startDate
        let calendar = Calendar.current

        while currentDate >= endDate {
            let sleepDuration = Double.random(in: 4 * 3600 ... 9 * 3600)
            let randomStartTime = Int.random(in: 21 ... 25)
            let startDateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)

            if let startDate = calendar.date(from: startDateComponents) {
                if let startTime = calendar.date(bySettingHour: randomStartTime, minute: Int.random(in: 0 ... 59), second: Int.random(in: 0 ... 59), of: startDate) {
                    let endTime = startTime.addingTimeInterval(sleepDuration)

                    sleepData.append((date: currentDate, startTime: startTime, endTime: endTime, duration: sleepDuration))
                } else {
                    print("Blad przy wyliczeniu obecnej daty: \(currentDate) | RandomStartTime: \(randomStartTime)")
                }
            } else {
                print("Blad przy tworzeniu komponentu z dzisiejszej daty: \(currentDate)")
            }

            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }

        return sleepData
    }

    func generateHighHeartRateData(startDate: Date, endDate: Date) -> [(date: Date, startTime: Date, endTime: Date, highHeartRate: Int)] {
        var currentDate = startDate
        let calendar = Calendar.current

        while currentDate >= endDate {
            let highHeartRate = Int.random(in: 90 ... 150)
            let randomStartTime = Int.random(in: 9 ... 23)
            let startDateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)

            if let startDate = calendar.date(from: startDateComponents) {
                if let startTime = calendar.date(bySettingHour: randomStartTime, minute: Int.random(in: 0 ... 59), second: Int.random(in: 0 ... 59), of: startDate) {
                    let endTime = calendar.date(byAdding: .second, value: Int.random(in: 15 ... 150), to: startTime)!

                    heartRateData.append((date: currentDate, startTime: startTime, endTime: endTime, highHeartRate: highHeartRate))
                } else {
                    print("Blad przy wyliczeniu obecnej daty: \(currentDate)")
                }
            } else {
                print("Blad przy tworzeniu komponentu z dzisiejszej daty: \(currentDate)")
            }

            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }

        return heartRateData
    }
}
