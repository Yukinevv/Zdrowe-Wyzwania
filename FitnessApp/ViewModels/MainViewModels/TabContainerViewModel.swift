//
//  TabContainerViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 28/01/2024.
//

import Foundation

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
