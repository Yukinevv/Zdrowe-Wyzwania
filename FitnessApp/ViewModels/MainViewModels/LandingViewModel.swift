//
//  LandingViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 06/05/2023.
//

import Combine
import Foundation

final class LandingViewModel: ObservableObject {
    @Published var loginSignupPushed = false
    private let userService: UserServiceProtocol
    private var cancellables: [AnyCancellable] = []

    let title = "Zdrowe Wyzwania"
    let loginButtonTitle = "Zaloguj się"
    let loginButtonImageName = "person.crop.circle"
    let signupButtonTitle = "Zarejestruj się"
    let signupButtonImageName = "person.badge.plus"
    let alreadyButtonTitle = "Kontynuuj bez konta"
    let backgroundImageName = "background1"

    init(
        userService: UserServiceProtocol = UserService()
    ) {
        self.userService = userService
    }

    func signInAnonymously() {
        userService.signInAnonymously().sink { completion in
            switch completion {
            case let .failure(error):
                print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
