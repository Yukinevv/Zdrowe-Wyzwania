//
//  ExerciseTimeTests.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 28/12/2023.
//

@testable import FitnessApp
import Foundation
import HealthKit
import XCTest

final class ExerciseTimeTests: XCTestCase {
    var exersiceTimeInstance: HealthExerciseTimeViewModel!

    override func setUpWithError() throws {
        exersiceTimeInstance = HealthExerciseTimeViewModel()
    }

    override func tearDownWithError() throws {
        exersiceTimeInstance = nil
    }

    func testRequestExerciseTimeFromLastWeek() {
        // Przygotowanie
        let expectation = self.expectation(description: "Wywołano handler zakończenia")
        var receivedData: [HealthModel]?

        // Tworzenie mockowych danych
        let mockWorkouts = [
            HKWorkout.createMockWorkout(duration: 60, startDate: Date().addingTimeInterval(-80000), type: .running),
            HKWorkout.createMockWorkout(duration: 80, startDate: Date().addingTimeInterval(-160000), type: .running),
            HKWorkout.createMockWorkout(duration: 100, startDate: Date().addingTimeInterval(-120000), type: .running),
            HKWorkout.createMockWorkout(duration: 45, startDate: Date().addingTimeInterval(-100000), type: .running),
            HKWorkout.createMockWorkout(duration: 30, startDate: Date().addingTimeInterval(-200000), type: .running),
        ]

        // Działanie
        exersiceTimeInstance.requestExerciseTimeFromLastWeek { dane in
            receivedData = dane
            for value in dane {
                print("Data: \(value.date) | Wartosc: \(value.count)")
                if let type = value.type {
                    print("Typ: \(HKWorkout.getActivityTypeName(for: Int(type.rawValue)))")
                } else {
                    print("Typ: brak typu")
                }
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Sprawdzenie
        XCTAssertNotNil(receivedData, "Otrzymane dane nie powinny być nil")
        // XCTAssertEqual(receivedData?.count, mockWorkouts.count, "Liczba otrzymanych danych powinna być równa liczbie mockowych treningów")

//        for (index, receivedWorkout) in receivedData!.enumerated() {
//            let mockWorkout = mockWorkouts[index]
//            XCTAssertEqual(receivedWorkout.count, Int(mockWorkout.duration), "Czas trwania treningu powinien być taki sam jak w mockowych danych")
//            XCTAssertEqual(receivedWorkout.date, mockWorkout.startDate, "Data treningu powinna być taka sama jak w mockowych danych")
//            XCTAssertEqual(receivedWorkout.type, mockWorkout.workoutActivityType, "Typ aktywności treningu powinien być taki sam jak w mockowych danych")
//        }
    }
}

extension HKWorkout {
    static func createMockWorkout(duration: TimeInterval, startDate: Date, type: HKWorkoutActivityType) -> HKWorkout {
        return HKWorkout(activityType: type, start: startDate, end: startDate.addingTimeInterval(duration))
    }

    static func getActivityTypeName(for rawValue: Int) -> String {
        switch rawValue {
        case Int(HKWorkoutActivityType.running.rawValue):
            return "Running"
        case Int(HKWorkoutActivityType.cycling.rawValue):
            return "Cycling"
        case Int(HKWorkoutActivityType.swimming.rawValue):
            return "Swimming"
        case Int(HKWorkoutActivityType.walking.rawValue):
            return "Walking"
        case Int(HKWorkoutActivityType.yoga.rawValue):
            return "Yoga"
        case Int(HKWorkoutActivityType.dance.rawValue):
            return "Dance"
        case Int(HKWorkoutActivityType.pilates.rawValue):
            return "Pilates"
        case Int(HKWorkoutActivityType.crossTraining.rawValue):
            return "CrossTraining"
        case Int(HKWorkoutActivityType.elliptical.rawValue):
            return "Elliptical"
        case Int(HKWorkoutActivityType.rowing.rawValue):
            return "Rowing"
        case Int(HKWorkoutActivityType.traditionalStrengthTraining.rawValue):
            return "TraditionalStrengthTraining"
        case Int(HKWorkoutActivityType.coreTraining.rawValue):
            return "CoreTraining"
        case Int(HKWorkoutActivityType.tennis.rawValue):
            return "Tennis"
        case Int(HKWorkoutActivityType.golf.rawValue):
            return "Golf"
        case Int(HKWorkoutActivityType.boxing.rawValue):
            return "Boxing"
        case Int(HKWorkoutActivityType.mixedCardio.rawValue):
            return "MixedCardio"
        case Int(HKWorkoutActivityType.climbing.rawValue):
            return "Climbing"
        case Int(HKWorkoutActivityType.fencing.rawValue):
            return "Fencing"
        case Int(HKWorkoutActivityType.other.rawValue):
            return "Other"
        default:
            return "Unknown"
        }
    }
}
