//
//  CreateView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 17/04/2023.
//

import SwiftUI

struct CreateView: View {
    @StateObject var viewModel = CreateChallengeViewModel()

    var dropdownList: some View {
        VStack {
            DropdownView(viewModel: $viewModel.exerciseDropdown)
            DropdownView(viewModel: $viewModel.startAmountDropown)
            DropdownView(viewModel: $viewModel.increaseDropdown)
            DropdownView(viewModel: $viewModel.lengthDropdown)
        }
    }

    var mainContentView: some View {
        ScrollView {
            VStack {
                dropdownList
                Spacer()
                Button(action: {
                    viewModel.send(action: .createChallenge)
                }) {
                    HStack(spacing: 10) {
                        Spacer()
                        Image(systemName: "plus.circle")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(StaticData.staticData.isDarkMode ? .white : .black)
                        Text("Utwórz")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(StaticData.staticData.isDarkMode ? .white : .black)
                        Spacer()
                    }
                }.buttonStyle(PrimaryButtonStyle())
                    .frame(width: 200)
            }
        }
    }

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                mainContentView
            }
        }.alert(isPresented: Binding<Bool>.constant($viewModel.error.wrappedValue != nil)) {
            Alert(
                title: Text("Bład!"),
                message: Text($viewModel.error.wrappedValue?.localizedDescription ?? ""),
                dismissButton: .default(Text("OK"), action: {
                    viewModel.error = nil
                })
            )
        }
        .navigationBarTitle("Utwórz wyzwanie")
        .padding(.bottom, 15)
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
