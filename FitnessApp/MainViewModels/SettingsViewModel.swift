//
//  SettingsViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 06/05/2023.
//

import Combine
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @AppStorage("isDarkMode") private var isDarkMode = false
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
        switch itemViewModels[index].type {
        case .account:
            guard userService.currentUser?.email == nil else { return }
            loginSignupPushed = true
        case .mode:
            isDarkMode = !isDarkMode
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

    private func buildItems() {
        itemViewModels = [
            .init(title: userService.currentUser?.email ?? "Utworz konto", iconName: "person.circle", type: .account),
            .init(title: "Zmien na tryb \(isDarkMode ? "Jasny" : "Ciemny")", iconName: "lightbulb", type: .mode),
            .init(title: "Osiagniecia", iconName: "hexagon.bottomhalf.filled", type: .achievements),
            .init(title: "Polityka Prywatnosci", iconName: "shield", type: .privacy),
        ]

        if userService.currentUser?.email != nil {
            itemViewModels += [.init(title: "Wyloguj", iconName: "arrowshape.turn.up.left", type: .logout)]
        }
    }

    func onAppear() {
        buildItems()
    }
}
