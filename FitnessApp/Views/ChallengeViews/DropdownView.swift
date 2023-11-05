//
//  DropdownView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 17/04/2023.
//

import SwiftUI

struct DropdownView<T: DropdownItemProtocol>: View {
    @Binding var viewModel: T

    var actionSheet: ActionSheet {
        ActionSheet(
            title: Text("Wybrano"),
            buttons: viewModel.options.map { option in
                ActionSheet.Button.default(
                    Text(option.formatted)) {
                        viewModel.selectedOption = option
                    }
            }
        )
    }

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.headerTitle)
                    .font(.system(size: 22, weight: .semibold))
                Spacer()
            }.padding(.vertical, 5)
            Button(action: {
                viewModel.isSelected = true
            }) {
                HStack {
                    Text(viewModel.dropdownTitle)
                        .font(.system(size: 20, weight: .semibold))
                    Spacer()
                    Image(systemName: "arrowtriangle.down.circle")
                        .font(.system(size: 22, weight: .medium))
                }
            }.buttonStyle(PrimaryButtonStyle(fillColor: .primaryButton))
        }
        .actionSheet(isPresented: $viewModel.isSelected) {
            actionSheet
        }
        .padding(15)
    }
}
