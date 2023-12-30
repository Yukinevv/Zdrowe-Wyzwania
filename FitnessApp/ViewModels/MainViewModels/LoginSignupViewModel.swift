//
//  LoginSignupViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 06/05/2023.
//

import Combine
import SwiftUI

final class LoginSignupViewModel: ObservableObject {
    let mode: Mode
    @AppStorage("emailString") var emailString: String = ""
    @AppStorage("passwordString") var passwordString: String = ""
    @Published var emailText = ""
    @Published var passwordText = ""
    @Published var isValidFailed = false
    @Published var isValid = false
    @Published var isPushed = true
    @Published var isSave = false
    private(set) var emailPlaceholderText = "Email"
    private(set) var passwordPlaceholderText = "Hasło"
    private let userService: UserServiceProtocol
    private var cancellables: [AnyCancellable] = []

    init(
        mode: Mode,
        userService: UserServiceProtocol = UserService()
    ) {
        self.mode = mode
        self.userService = userService

        if !emailString.isEmpty {
            emailText = emailString
        }
        if !passwordString.isEmpty {
            passwordText = passwordString
        }

        Publishers.CombineLatest($emailText, $passwordText)
            .map { [weak self] email, password in
                self?.isValidEmail(email) == true && self?.isValidPassword(password) == true
            }.assign(to: &$isValid)
    }

    var title: String {
        switch mode {
        case .login:
            return "Witaj ponownie!"
        case .signup, .link:
            return "Załóż konto"
        }
    }

    var subtitle: String {
        switch mode {
        case .login:
            return "Zaloguj się"
        case .signup, .link:
            return "Zarejestruj się"
        }
    }

    var buttonTitle: String {
        switch mode {
        case .login:
            return "Zaloguj"
        case .signup, .link:
            return "Zarejestruj"
        }
    }

    func tappedActionButton() {
        switch mode {
        case .login:
            userService.login(email: emailText, password: passwordText).sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                    self.isValidFailed = true
                case .finished:
                    if self.isSave {
                        self.emailString = self.emailText
                        self.passwordString = self.passwordText
                    }
                    break
                }
            } receiveValue: { _ in }
                .store(in: &cancellables)
        case .signup:
            userService.signup(email: emailText, password: passwordText).sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { _ in }
                .store(in: &cancellables)
        case .link:
            userService.linkAccount(email: emailText, password: passwordText).sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    self?.isPushed = false
                }
            } receiveValue: { _ in }
                .store(in: &cancellables)
        }
    }
}

extension LoginSignupViewModel {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email) && email.count > 5
    }

    func isValidPassword(_ password: String) -> Bool {
        return password.count > 5
    }
}

extension LoginSignupViewModel {
    enum Mode {
        case login
        case signup
        case link
    }
}
