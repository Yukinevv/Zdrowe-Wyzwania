//
//  ChallengeListView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 06/05/2023.
//

import SwiftUI

struct ChallengeListView: View {
    @StateObject private var viewModel = ChallengeListViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                VStack {
                    Text(error.localizedDescription)
                    Button("Ponow") {
                        viewModel.send(action: .retry)
                    }
                    .padding(10)
                    .background(Rectangle().fill(Color.red).cornerRadius(5))
                }
            } else {
                mainContentView
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
                        viewModel.send(action: .timeChange)
                    }
            }
        }
    }

    var mainContentView: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [.init(.flexible())]) {
                    ForEach(viewModel.itemViewModel, id: \.id) { viewModel in
                        ChallengeItemView(viewModel: viewModel)
                    }
                }
                Spacer()
            }.padding(10)

            if viewModel.itemViewModel.count == 0 {
                Spacer()
                    .frame(height: 100)
                Text("Tu pojawia sie Twoje wyzwania")
            }
        }
        .sheet(isPresented: $viewModel.showingCreateModal) {
            NavigationView {
                CreateView()
                    .navigationBarBackButtonHidden(true)
            }.preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .navigationBarItems(
            trailing: Button {
                viewModel.send(action: .create)
            } label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            })
        .navigationTitle(viewModel.title)
    }
}

struct ChallengeListView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeListView()
    }
}
