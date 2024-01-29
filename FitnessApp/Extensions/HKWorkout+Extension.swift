//
//  HKWorkout+Extension.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import HealthKit

extension HKWorkout {
    /// Metoda generuje dane odnosnie treningu z wybranego dnia
    ///
    /// - Parameters:
    ///   - daysAgo: z przed ilu dni ma zostac wygenerowany trening
    ///   - activityType: typ generowanego treningu
    static func generateWorkoutWithActivity(daysAgo: Int, activityType: HKWorkoutActivityType) -> HKWorkout {
        let totalEnergyBurned = Double.random(in: 350 ..< 650)
        let totalDistance = Double.random(in: 1500 ..< 6500)
        let duration = Double.random(in: 3500 ..< 7500)

        let today = Date()
        let start = Calendar.current.date(byAdding: .day, value: -daysAgo, to: today)!
        let end = Calendar.current.date(byAdding: .minute, value: 60, to: start)!

        let workout = HKWorkout(
            activityType: activityType,
            start: start,
            end: end,
            duration: duration,
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: totalEnergyBurned),
            totalDistance: HKQuantity(unit: .meter(), doubleValue: totalDistance),
            device: nil, metadata: nil)
        return workout
    }

    // Mapowanie liczby calkowitej na typ treningu
    static func getActivityType(for number: Int) -> HKWorkoutActivityType? {
        switch number {
        case 1:                                 return .americanFootball
        case 2:                                 return .archery
        case 3:                                 return .badminton
        case 4:                                 return .baseball
        case 5:                                 return .basketball
        case 6:                                 return .bowling
        case 7:                                 return .boxing
        case 8:                                 return .climbing
        case 9:                                 return .crossTraining
        case 10:                                return .curling
        case 11:                                return .cycling
        case 12:                                return .dance
        case 13:                                return .danceInspiredTraining
        case 14:                                return .elliptical
        case 15:                                return .equestrianSports
        case 16:                                return .fencing
        case 17:                                return .fishing
        case 18:                                return .functionalStrengthTraining
        case 19:                                return .golf
        case 20:                                return .gymnastics
        case 21:                                return .handball
        case 22:                                return .hiking
        case 23:                                return .hockey
        case 24:                                return .hunting
        case 25:                                return .lacrosse
        case 26:                                return .martialArts
        case 27:                                return .mindAndBody
        case 28:                                return .mixedMetabolicCardioTraining
        case 29:                                return .paddleSports
        case 30:                                return .play
        case 31:                                return .preparationAndRecovery
        case 32:                                return .racquetball
        case 33:                                return .rowing
        case 34:                                return .rugby
        case 35:                                return .running
        case 36:                                return .sailing
        case 37:                                return .skatingSports
        case 38:                                return .snowSports
        case 39:                                return .soccer
        case 40:                                return .softball
        case 41:                                return .squash
        case 42:                                return .stairClimbing
        case 43:                                return .surfingSports
        case 44:                                return .swimming
        case 45:                                return .tableTennis
        case 46:                                return .tennis
        case 47:                                return .trackAndField
        case 48:                                return .traditionalStrengthTraining
        case 49:                                return .volleyball
        case 50:                                return .walking
        case 51:                                return .waterFitness
        case 52:                                return .waterPolo
        case 53:                                return .waterSports
        case 54:                                return .wrestling
        case 55:                                return .yoga
        case 56:                                return .barre
        case 57:                                return .coreTraining
        case 58:                                return .crossCountrySkiing
        case 59:                                return .downhillSkiing
        case 60:                                return .flexibility
        case 61:                                return .highIntensityIntervalTraining
        case 62:                                return .jumpRope
        case 63:                                return .kickboxing
        case 64:                                return .pilates
        case 65:                                return .snowboarding
        case 66:                                return .stairs
        case 67:                                return .stepTraining
        case 68:                                return .wheelchairWalkPace
        case 69:                                return .wheelchairRunPace
        case 70:                                return .taiChi
        case 71:                                return .mixedCardio
        case 72:                                return .handCycling
        case 73:                                return .discSports
        case 74:                                return .fitnessGaming

        default:                                return nil
        }
    }

}
