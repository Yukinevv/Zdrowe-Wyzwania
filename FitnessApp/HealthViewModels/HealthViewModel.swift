//
//  HealthViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 09/05/2023.
//

import SwiftUI

final class HealthViewModel: ObservableObject {
    @Published var items: [HealthItemViewModel] = [
        .init(title: "Kroki", value: "0", icon: "figure.walk", type: .steps, showModal: false),
        .init(title: "Kalorie", value: "0", icon: "flame.fill", type: .calory, showModal: false),
        .init(title: "Czas treningu", value: "0", icon: "clock", type: .exerciseTime, showModal: false),
        .init(title: "Dystans", value: "0", icon: "figure.walk.circle", type: .distanceWalkingRunning, showModal: false),
        .init(title: "Wysokie tetno", value: "0", icon: "heart.fill", type: .highHeartRate, showModal: false),
        .init(title: "Czas snu", value: "0", icon: "moon.zzz", type: .sleepTime, showModal: false),
    ]

    @Published var showingModal = false

    func tappedItem(at index: Int) -> AnyView {
        switch items[index].type {
        case .steps:
            // return AnyView(GraphView())
            return AnyView(CountStepsView())
        case .calory:
            return AnyView(CaloriesBurnedView())
        case .exerciseTime:
            return AnyView(ExerciseTimeView())
        case .sleepTime:
            return AnyView(SleepTimeView())
        case .distanceWalkingRunning:
            return AnyView(DistanceWalkingRunningView())
        case .highHeartRate:
            return AnyView(HighHeartRateView())
        }
    }
}

struct HealthItemViewModel: Hashable {
    let title: String
    var value: String
    let icon: String
    let type: HealthType
    var showModal: Bool

    enum HealthType {
        case steps
        case calory
        case exerciseTime
        case sleepTime
        case distanceWalkingRunning
        case highHeartRate
    }
}
