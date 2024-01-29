//
//  TabContainerView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 02/05/2023.
//

import SwiftUI

struct TabContainerView: View {
    @StateObject private var tabContainerViewModel = TabContainerViewModel()

    var body: some View {
        TabView(selection: $tabContainerViewModel.selectedTab) {
            ForEach(tabContainerViewModel.tabItemViewModels, id: \.self) { viewModel in
                tabView(for: viewModel.type)
                    .tabItem {
                        Image(systemName: viewModel.imageName)
                        Text(viewModel.title)
                    }
                    .tag(viewModel.type)
            }
        }
    }

    /// Metoda zwraca odpowiedni widok w zaleznosci od podanego parametru
    ///
    /// - Parameters:
    ///   - tabItemType: Okresla typ widoku
    @ViewBuilder
    func tabView(for tabItemType: TabItemViewModel.TabItemType) -> some View {
        switch tabItemType {
        case .health:
            NavigationView {
                HealthDashboardView()
            }
        case .stats:
            NavigationView {
                HealthWorkoutView()
            }
        case .trends:
            NavigationView {
                HealthTrendsView()
                    .environmentObject(HealthTrendsViewModel())
            }
        case .challengeList:
            NavigationView {
                ChallengeListView()
            }
        case .settings:
            NavigationView {
                SettingsView()
            }
        }
    }
}
