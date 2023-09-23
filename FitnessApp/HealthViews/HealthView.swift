//
//  HealthView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 09/05/2023.
//

import SwiftUI

struct HealthView: View {
    @StateObject private var viewModel = HealthViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    var healthData: HealthData = HealthData()
    // var healthData2: HealthData2 = HealthData2()

    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                    .frame(height: 10)
                LazyVGrid(columns: [.init(.flexible(), spacing: 20), .init(.flexible(), spacing: 20)]) {
                    ForEach(viewModel.items.indices, id: \.self) { index in
                        VStack(spacing: 15) {
                            Image(systemName: viewModel.items[index].icon)
                                .font(.system(size: 28, weight: .medium))

                            Text("\(viewModel.items[index].title): \(viewModel.items[index].value)")
                                .font(.system(size: 24, weight: .medium))
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                        }
                        .padding(10)
                        .frame(width: 150, height: 120)
                        .background(
                            Rectangle()
                                .fill(isDarkMode ? Color.lightGreen : Color.primaryButton)
                                .cornerRadius(15)
                        ).padding()
                        .onTapGesture {
                            viewModel.items[index].showModal = true
                        }
                        .sheet(isPresented: $viewModel.items[index].showModal) {
                            NavigationView {
                                viewModel.tappedItem(at: index)
                                    .navigationTitle(viewModel.items[index].title)
                            }.preferredColorScheme(isDarkMode ? .dark : .light)
                        }
                    }
                }
                Spacer()
            }.padding(10)
        }
        .navigationTitle("Zdrowie")
        .onAppear {
            viewModel.items[0].value = String(healthData.steps)
            viewModel.items[1].value = String(healthData.calories)
            viewModel.items[2].value = String(healthData.exerciseTime)
            DispatchQueue.main.async {
                healthData.requestSleepTime()
                viewModel.items[3].value = healthData.sleepTime
            }
            viewModel.items[4].value = String(healthData.distanceWalkingRunning)
            viewModel.items[5].value = String(healthData.highHeartRate)

//            viewModel.items[0].value = healthData2.requestStepCount()
//            viewModel.items[1].value = healthData2.requestCaloriesBurned()
//            viewModel.items[2].value = healthData2.requestExerciseTime()
//            viewModel.items[3].value = healthData2.requestSleepTime()
        }
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}
