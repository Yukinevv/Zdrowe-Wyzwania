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
                    .environmentObject(HealthWorkoutViewModel())
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

final class TabContainerViewModel: ObservableObject {
    @Published var selectedTab: TabItemViewModel.TabItemType = .health

    let tabItemViewModels = [
        TabItemViewModel(imageName: "heart.fill", title: "Zdrowie", type: .health),
        .init(imageName: "chart.bar.xaxis", title: "Statystyki", type: .stats),
        .init(imageName: "chart.line.uptrend.xyaxis", title: "Trendy", type: .trends),
        .init(imageName: "figure.highintensity.intervaltraining", title: "Wyzwania", type: .challengeList),
        .init(imageName: "gear", title: "Ustawienia", type: .settings),
    ]
}

struct TabItemViewModel: Hashable {
    let imageName: String
    let title: String
    let type: TabItemType

    enum TabItemType {
        case health
        case stats
        case trends
        case challengeList
        case settings
    }
}
