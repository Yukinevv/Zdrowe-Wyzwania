//
//  CreateChallengeViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 18/04/2023.
//

import Combine
import SwiftUI

typealias UserId = String

final class CreateChallengeViewModel: ObservableObject {
    @Published var exerciseDropdown = ChallengePartViewModel(type: .exercise)
    @Published var startAmountDropown = ChallengePartViewModel(type: .startAmount)
    @Published var increaseDropdown = ChallengePartViewModel(type: .increase)
    @Published var lengthDropdown = ChallengePartViewModel(type: .length)

    @Published var error: CustomError?
    @Published var isLoading = false

    private let userService: UserServiceProtocol
    private let challengeService: ChallengeServiceProtocol
    private var cancellables: [AnyCancellable] = []

    enum Action {
        case createChallenge
    }

    init(
        userService: UserServiceProtocol = UserService(),
        challengeService: ChallengeServiceProtocol = ChallengeService()
    ) {
        self.userService = userService
        self.challengeService = challengeService
    }

    func send(action: Action) {
        switch action {
        case .createChallenge:
            isLoading = true
            currentUserId().flatMap { userId -> AnyPublisher<Void, CustomError> in
                self.createChallenge(userId: userId)
            }.sink { completion in
                self.isLoading = false
                switch completion {
                case let .failure(error):
                    self.error = error
                case .finished:
                    break
                }
            } receiveValue: { _ in
            }.store(in: &cancellables)
        }
    }

    private func createChallenge(userId: UserId) -> AnyPublisher<Void, CustomError> {
        guard let exercise = exerciseDropdown.text,
              let startAmount = startAmountDropown.number,
              let increase = increaseDropdown.number,
              let length = lengthDropdown.number else {
            return Fail(error: .default(description: "Parsing error")).eraseToAnyPublisher()
        }

        let startDate = Calendar.current.startOfDay(for: Date())

        let challenge = ChallengeModel(
            exercise: exercise,
            startAmount: startAmount,
            increase: increase,
            length: length,
            userId: userId,
            startDate: startDate,
            activities: (0 ..< length).compactMap { dayNum in
                if let dateForDayNum = Calendar.current.date(byAdding: .day, value: dayNum, to: startDate) {
                    return .init(date: dateForDayNum, isComplete: false)
                } else {
                    return nil
                }
            }
        )

        return challengeService.create(challenge).eraseToAnyPublisher()
    }

    private func currentUserId() -> AnyPublisher<UserId, CustomError> {
        return userService.currentUserPublisher().flatMap { user -> AnyPublisher<UserId, CustomError> in
            if let userId = user?.uid {
                return Just(userId)
                    .setFailureType(to: CustomError.self)
                    .eraseToAnyPublisher()
            } else {
                return self.userService
                    .signInAnonymously()
                    .map { $0.uid }
                    .eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
}

extension CreateChallengeViewModel {
    struct ChallengePartViewModel: DropdownItemProtocol {
        var selectedOption: DropdownOption

        var options: [DropdownOption]

        var headerTitle: String {
            type.rawValue
        }

        var dropdownTitle: String {
            selectedOption.formatted
        }

        var isSelected: Bool = false

        private let type: ChallengePartType

        init(type: ChallengePartType) {
            switch type {
            case .exercise:
                options = ExerciseOption.allCases.map { $0.toDropdownOption }
            case .startAmount:
                options = StartOption.allCases.map { $0.toDropdownOption }
            case .increase:
                options = IncreaseOption.allCases.map { $0.toDropdownOption }
            case .length:
                options = LengthOption.allCases.map { $0.toDropdownOption }
            }
            self.type = type
            selectedOption = options.first!
        }

        enum ChallengePartType: String, CaseIterable {
            case exercise = "Ćwiczenie"
            case startAmount = "Ilość powtórzen"
            case increase = "Dzienny wzrost"
            case length = "Długosc wyzwania"
        }

        enum ExerciseOption: String, CaseIterable, DropdownOptionProtocol {
            case situps = "Przysiady"
            case pullups = "Podciągnięcia"
            case pushups = "Pompki"

            var toDropdownOption: DropdownOption {
                .init(
                    type: .text(rawValue),
                    formatted: rawValue.capitalized
                )
            }
        }

        enum StartOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five

            var toDropdownOption: DropdownOption {
                .init(
                    type: .number(rawValue),
                    formatted: "\(rawValue)"
                )
            }
        }

        enum IncreaseOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five

            var toDropdownOption: DropdownOption {
                .init(
                    type: .number(rawValue),
                    formatted: "+\(rawValue)"
                )
            }
        }

        enum LengthOption: Int, CaseIterable, DropdownOptionProtocol {
            case seven = 7, fourteen = 14, twentyOne = 21, twentyEight = 28

            var toDropdownOption: DropdownOption {
                .init(
                    type: .number(rawValue),
                    formatted: "\(rawValue) dni"
                )
            }
        }
    }
}

extension CreateChallengeViewModel.ChallengePartViewModel {
    var text: String? {
        if case let .text(text) = selectedOption.type {
            return text
        }
        return nil
    }

    var number: Int? {
        if case let .number(number) = selectedOption.type {
            return number
        }
        return nil
    }
}
