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
            let steps = [
                Step(count: 5632, date: Date()),
                Step(count: 312, date: Date()),
                Step(count: 1542, date: Date()),
                Step(count: 6342, date: Date()),
                Step(count: 11376, date: Date()),
            ]

            NavigationView {
                GraphView(steps: steps)
                    .navigationTitle("Zdrowie")
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
    @Published var selectedTab: TabItemViewModel.TabItemType = .challengeList

    let tabItemViewModels = [
        TabItemViewModel(imageName: "heart.fill", title: "Zdrowie", type: .health),
        .init(imageName: "list.bullet", title: "Wyzwania", type: .challengeList),
        .init(imageName: "gear", title: "Ustawienia", type: .settings),
    ]
}

struct TabItemViewModel: Hashable {
    let imageName: String
    let title: String
    let type: TabItemType

    enum TabItemType {
        case health
        case challengeList
        case settings
    }
}
