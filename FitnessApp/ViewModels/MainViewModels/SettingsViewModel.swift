//
//  SettingsViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 06/05/2023.
//

import Combine
import SwiftUI

final class SettingsViewModel: ObservableObject {
    // @AppStorage("isDarkMode") private var isDarkMode = false
    @Published private(set) var itemViewModels: [SettingsItemViewModel] = []
    @Published var loginSignupPushed = false
    let title = "Ustawienia"
    private let userService: UserServiceProtocol
    private var cancellables: [AnyCancellable] = []

    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }

    func item(at index: Int) -> SettingsItemViewModel {
        return itemViewModels[index]
    }

    func tappedItem(at index: Int) {
        switch itemViewModels[index].action {
        case .account:
            guard userService.currentUser?.email == nil else { return }
            loginSignupPushed = true
        case .mode:
            StaticData.staticData.isDarkMode = !StaticData.staticData.isDarkMode
            buildItems()
        case .achievements:
            break
        case .logout:
            userService.logout().sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { _ in }
                .store(in: &cancellables)
        default:
            break
        }
    }

    func tappedNavigationItem(at index: Int) -> AnyView {
        switch itemViewModels[index].destination {
        case "achievements":
            return AnyView(AchievementsView())
        case "privacyPolicy":
            return AnyView(PrivacyPolicyView())
        default:
            return AnyView(EmptyView())
        }
    }

    private func buildItems() {
        itemViewModels = [
            .init(type: .button, title: userService.currentUser?.email ?? "Utwórz konto", iconName: "person.circle", action: .account, destination: ""),
            .init(type: .navigationLink, title: "Osiągnięcia", iconName: "medal.fill", action: .achievements, destination: "achievements"),
            .init(type: .navigationLink, title: "Polityka Prywatności", iconName: "shield", action: .privacy, destination: "privacyPolicy"),
            .init(type: .button, title: "Zmień na tryb \(StaticData.staticData.isDarkMode ? "Jasny" : "Ciemny")", iconName: "lightbulb", action: .mode, destination: ""),
        ]

        if userService.currentUser?.email != nil {
            itemViewModels += [.init(type: .button, title: "Wyloguj", iconName: "arrowshape.turn.up.left", action: .logout, destination: "")]
        }
    }

    func onAppear() {
        buildItems()
    }
}
