//
//  FitnessApp.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 10/04/2023.
//

import Firebase
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct FitnessApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                TabContainerView()
                    .preferredColorScheme(StaticData.staticData.isDarkMode ? .dark : .light)
            } else {
                LandingPage()
            }
        }
    }
}

class AppState: ObservableObject {
    @Published private(set) var isLoggedIn = false

    private let userService: UserServiceProtocol

    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        try? Auth.auth().signOut()
        userService
            .observeAuthChanges()
            .map { $0 != nil }
            .assign(to: &$isLoggedIn)
    }
}
