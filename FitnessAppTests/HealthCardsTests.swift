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
        let stepCount: Double = 2500

        // Działanie
        healthCardsInstance.requestStepCount2 { dane in
            receivedData = dane
            if let stepData = receivedData {
                print("Kroki: \(stepData)")
            } else {
                print("Kroki: nil")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Sprawdzenie
        XCTAssertNotNil(receivedData, "Otrzymane dane nie powinny być nil")
        XCTAssertEqual(receivedData, stepCount, "Liczba otrzymanych kroków powinna być równa liczbie mockowych kroków")
    }
}
