//
//  HealthCardsTests.swift
//  FitnessAppTests
//
//  Created by Adrian Rodzic on 28/12/2023.
//

@testable import FitnessApp
import Foundation
import HealthKit
import XCTest

final class HealthCardsTests: XCTestCase {
    var healthCardsInstance: HealthCardsViewModel!

    override func setUpWithError() throws {
        healthCardsInstance = HealthCardsViewModel()
    }

    override func tearDownWithError() throws {
        healthCardsInstance = nil
    }

    func testRequestStepCount() {
        // Przygotowanie
        let expectation = self.expectation(description: "Wywołano handler zakończenia")
        var receivedData: Double?

        // Tworzenie mockowych danych
        let mockData: Double = 4200

        // Działanie
        healthCardsInstance.requestStepCount { data in
            receivedData = data
            if let unwrapedData = receivedData {
                print("Kroki: \(unwrapedData)")
            } else {
                print("Kroki: nil")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Sprawdzenie
        XCTAssertNotNil(receivedData, "Otrzymane dane nie powinny być nil")
        XCTAssertEqual(receivedData, mockData, "Wartość otrzymanych danych powinna być równa wartości mockowych danych")
    }

    func testRequestCaloriesBurned() {
        // Przygotowanie
        let expectation = self.expectation(description: "Wywołano handler zakończenia")
        var receivedData: Double?

        // Tworzenie mockowych danych
        let mockData: Double = 350

        // Działanie
        healthCardsInstance.requestCaloriesBurned { data in
            receivedData = data
            if let unwrapedData = receivedData {
                print("Kalorie: \(unwrapedData)")
            } else {
                print("Kalorie: nil")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Sprawdzenie
        XCTAssertNotNil(receivedData, "Otrzymane dane nie powinny być nil")
        XCTAssertEqual(receivedData, mockData, "Wartość otrzymanych danych powinna być równa wartości mockowych danych")
    }

    func testRequestSleepData() {
        // Przygotowanie
        let expectation = self.expectation(description: "Wywołano handler zakończenia")
        var receivedData: Double?

        // Tworzenie mockowych danych
        let mockData: Double = 7

        // Działanie
        healthCardsInstance.requestSleepData { data in
            receivedData = data
            if let unwrapedData = receivedData {
                print("Sen: \(unwrapedData)")
            } else {
                print("Sen: nil")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Sprawdzenie
        XCTAssertNotNil(receivedData, "Otrzymane dane nie powinny być nil")
        XCTAssertEqual(receivedData, mockData, "Wartość otrzymanych danych powinna być równa wartości mockowych danych")
    }

    func testRequestWaterData() {
        // Przygotowanie
        let expectation = self.expectation(description: "Wywołano handler zakończenia")
        var receivedData: Double?

        // Tworzenie mockowych danych
        let mockData: Double = 3

        // Działanie
        healthCardsInstance.requestWaterData { data in
            receivedData = data
            if let unwrapedData = receivedData {
                print("Nawodnienie: \(unwrapedData)")
            } else {
                print("Nawodnienie: nil")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Sprawdzenie
        XCTAssertNotNil(receivedData, "Otrzymane dane nie powinny być nil")
        XCTAssertEqual(receivedData, mockData, "Wartość otrzymanych danych powinna być równa wartości mockowych danych")
    }

    func testRequestHighHeartRate() {
        // Przygotowanie
        let expectation = self.expectation(description: "Wywołano handler zakończenia")
        var receivedData: Double?

        // Tworzenie mockowych danych
        let mockData: Double = 122

        // Działanie
        healthCardsInstance.requestHighHeartRateData { data in
            receivedData = data
            if let unwrapedData = receivedData {
                print("Tętno: \(unwrapedData)")
            } else {
                print("Tętno: nil")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Sprawdzenie
        XCTAssertNotNil(receivedData, "Otrzymane dane nie powinny być nil")
        XCTAssertGreaterThan(receivedData ?? 0, 100, "Otrzymane tętno powinno być wyższe od 100 ud / min")
        XCTAssertEqual(receivedData, mockData, "Otrzymane tętno powinno być wyższe od 100 ud / min")
    }

    func testRequestWorkoutTime() {
        // Przygotowanie
        let expectation = self.expectation(description: "Wywołano handler zakończenia")
        var receivedData: Double?

        // Tworzenie mockowych danych
        let mockData: Double = 0.75 // 45 min

        // Działanie
        healthCardsInstance.requestWorkoutTimeData { data in
            receivedData = data
            if let unwrapedData = receivedData {
                print("Czas treningu: \(unwrapedData)")
            } else {
                print("Czas treningu: nil")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Sprawdzenie
        XCTAssertNotNil(receivedData, "Otrzymane dane nie powinny być nil")
        XCTAssertGreaterThan(receivedData ?? 0, 0.12, "Czas treningu powinien być dłuższy niż 5 min")
        XCTAssertEqual(receivedData, mockData, "Wartość otrzymanych danych powinna być równa wartości mockowych danych")
    }
}
