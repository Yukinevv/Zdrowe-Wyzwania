//
//  HealthCardsPerformanceTests.swift
//  FitnessAppTests
//
//  Created by Adrian Rodzic on 21/01/2024.
//

@testable import FitnessApp
import Foundation
import HealthKit
import XCTest

final class HealthCardsPerformanceTests: XCTestCase {
    var healthCardsInstance: HealthCardsViewModel!

    override func setUp() {
        super.setUp()
        healthCardsInstance = HealthCardsViewModel()
    }

    func testPerformanceOfStepCountRequest() {
        let iterations = 10

        measure {
            let expectation = self.expectation(description: "Wywołano handler zakończenia \(iterations) razy")
            expectation.expectedFulfillmentCount = iterations

            for _ in 0 ..< iterations {
                healthCardsInstance.requestStepCount { _, _ in
                    expectation.fulfill()
                }
            }

            self.waitForExpectations(timeout: 5, handler: nil)
        }
    }

    func testPerformanceOfCaloriesBurnedRequest() {
        let iterations = 10

        measure {
            let expectation = self.expectation(description: "Wywołano handler zakończenia \(iterations) razy")
            expectation.expectedFulfillmentCount = iterations

            for _ in 0 ..< iterations {
                healthCardsInstance.requestCaloriesBurned { _, _ in
                    expectation.fulfill()
                }
            }

            self.waitForExpectations(timeout: 5, handler: nil)
        }
    }

    func testPerformanceOfSleepDataRequest() {
        let iterations = 10

        measure {
            let expectation = self.expectation(description: "Wywołano handler zakończenia \(iterations) razy")
            expectation.expectedFulfillmentCount = iterations

            for _ in 0 ..< iterations {
                healthCardsInstance.requestSleepData { _, _ in
                    expectation.fulfill()
                }
            }

            self.waitForExpectations(timeout: 5, handler: nil)
        }
    }

    func testPerformanceOfWaterDataRequest() {
        let iterations = 10

        measure {
            let expectation = self.expectation(description: "Wywołano handler zakończenia \(iterations) razy")
            expectation.expectedFulfillmentCount = iterations

            for _ in 0 ..< iterations {
                healthCardsInstance.requestWaterData { _, _ in
                    expectation.fulfill()
                }
            }

            self.waitForExpectations(timeout: 5, handler: nil)
        }
    }

    func testPerformanceOfHighHeartRateRequest() {
        let iterations = 10

        measure {
            let expectation = self.expectation(description: "Wywołano handler zakończenia \(iterations) razy")
            expectation.expectedFulfillmentCount = iterations

            for _ in 0 ..< iterations {
                healthCardsInstance.requestHighHeartRateData { _, _ in
                    expectation.fulfill()
                }
            }

            self.waitForExpectations(timeout: 5, handler: nil)
        }
    }

    func testPerformanceOfWorkoutTimeDataRequest() {
        let iterations = 10

        measure {
            let expectation = self.expectation(description: "Wywołano handler zakończenia \(iterations) razy")
            expectation.expectedFulfillmentCount = iterations

            for _ in 0 ..< iterations {
                healthCardsInstance.requestWorkoutTimeData { _, _ in
                    expectation.fulfill()
                }
            }

            self.waitForExpectations(timeout: 5, handler: nil)
        }
    }
}
