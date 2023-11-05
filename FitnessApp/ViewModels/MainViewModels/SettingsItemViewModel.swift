//
//  SettingsItemViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 06/05/2023.
//

import Foundation

extension SettingsViewModel {
    struct SettingsItemViewModel {
        let title: String
        let iconName: String
        let type: SettingsItemType
    }

    enum SettingsItemType {
        case account
        case mode
        case achievements
        case privacy
        case logout
    }
}
