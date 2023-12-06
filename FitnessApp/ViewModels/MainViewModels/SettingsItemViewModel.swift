//
//  SettingsItemViewModel.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 06/05/2023.
//

import Foundation

extension SettingsViewModel {
    struct SettingsItemViewModel {
        let type: SettingsItemType
        let title: String
        let iconName: String
        let action: SettingsItemAction
        let destination: String
    }

    enum SettingsItemType {
        case button
        case navigationLink
    }

    enum SettingsItemAction {
        case account
        case mode
        case achievements
        case privacy
        case logout
    }
}
