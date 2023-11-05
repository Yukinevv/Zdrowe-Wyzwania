//
//  HealthCardViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 15/10/2023.
//

import SwiftUI

class HealthCardViewModel {
    @AppStorage("stepsGoal") var stepsGoal: String = ""
    @AppStorage("caloriesGoal") var caloriesGoal: String = ""
    @AppStorage("sleepGoal") var sleepGoal: String = ""
    @AppStorage("waterGoal") var waterGoal: String = ""
    @AppStorage("heartRateGoal") var heartRateGoal: String = ""
    @AppStorage("workoutTimeGoal") var workoutTimeGoal: String = ""

    func updateStatsGoalData(goal: Double, title: String) -> Double {
        switch title {
        case "Kroki":
            return Double(stepsGoal) ?? goal
        case "Kalorie":
            return Double(caloriesGoal) ?? goal
        case "Sen":
            return Double(sleepGoal) ?? goal
        case "Nawodnienie":
            return Double(waterGoal) ?? goal
        case "Tętno":
            return Double(heartRateGoal) ?? goal
        case "Czas treningu":
            return Double(workoutTimeGoal) ?? goal
        default:
            return 0.0
        }
    }

    @ViewBuilder
    func getHealthView(for title: String, value: Double) -> some View {
        switch title {
        case "Kroki":
            HealthDailyStepsChartsView().environmentObject(HealthDailyStepsViewModel())
        case "Kalorie":
            HealthCaloriesBurnedView()
        case "Sen":
            HealthSleepTimeView()
        case "Nawodnienie":
            WaterCardView(value: value)
        case "Tętno":
            HealthHighHeartRateView()
        case "Czas treningu":
            HealthExerciseTimeView()
        default:
            EmptyView()
        }
    }

    func getValue(_ value: Double, title: String) -> Double {
        switch title {
        case "Kroki":
            return value
        case "Kalorie":
            return value
        case "Sen":
            return value
        case "Nawodnienie":
            return value
        case "Tętno":
            return value
        case "Czas treningu":
            return value * 60 // w minutach
        default:
            return value
        }
    }

    func getType(title: String) -> String {
        switch title {
        case "Kroki": return "kroków"
        case "Kalorie": return "kcal"
        case "Sen": return ""
        case "Nawodnienie": return "L"
        case "Tętno": return "bpm"
        case "Czas treningu": return "min"
        default: return "default"
        }
    }

    func getValueForPrint(value: Double, title: String) -> String {
        switch title {
        case "Kroki":
            return getDec(val: value)
        case "Kalorie":
            return getDec(val: value)
        case "Sen":
            return convertToTimeString(hours: value) // w godzinach i minutach
        case "Nawodnienie":
            return getDec(val: value)
        case "Tętno":
            return getDec(val: value)
        case "Czas treningu":
            return getDec(val: value * 60) // w minutach
        default:
            return getDec(val: value)
        }
    }

    // Converting Numbers to Decimals
    func getDec(val: CGFloat) -> String {
        let format = NumberFormatter()
        format.numberStyle = .decimal

        return format.string(from: NSNumber(value: Float(val)))!
    }

    func convertToTimeString(hours: Double) -> String {
        let hoursInt = Int(hours)
        let minutes = Int((hours - Double(hoursInt)) * 60)

        var timeString = ""
        if hoursInt > 0 {
            timeString += "\(hoursInt) h "
        }
        if minutes > 0 {
            timeString += "\(minutes) min"
        }
        if timeString == "" {
            timeString += "0 h"
        }
        return timeString
    }

    // Calculates the percentage for the stats area
    func getPercent(current: CGFloat, goal: CGFloat) -> String {
        let per = (current / goal) * 100
        return String(format: "%.1f", per)
    }
}
