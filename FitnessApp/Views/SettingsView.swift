//
//  SettingsView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 06/05/2023.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        VStack {
            List(viewModel.itemViewModels.indices, id: \.self) { index in
                Button {
                    viewModel.tappedItem(at: index)
                } label: {
                    HStack {
                        Image(systemName: viewModel.item(at: index).iconName)
                        Text(viewModel.item(at: index).title)
                    }
                }
            }
        }
        .background(
            NavigationLink(
                destination: LoginSignupView(
                    mode: .link,
                    isPushed: $viewModel.loginSignupPushed
                ), isActive: $viewModel.loginSignupPushed) {
                }
        )
        .navigationTitle(viewModel.title)
        .onAppear {
            viewModel.onAppear()
        }
    }
}
