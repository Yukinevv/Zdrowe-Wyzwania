//
//  HealthSleepTimeView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 18/06/2023.
//

import HealthKit
import SwiftUI

struct HealthSleepTimeView: View {
    var viewModel: HealthSleepTimeViewModel = HealthSleepTimeViewModel()

    @State var data: [HKSample] = []

    let staticData = StaticData.staticData

    var body: some View {
        ScrollView {
            Spacer().frame(height: 20)
            VStack(spacing: 15) {
                if !staticData.isTestData && !data.isEmpty {
                    ForEach(data.indices, id: \.self) { index in
                        VStack(spacing: 5) {
                            HStack {
                                Text("Początek:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(data[index].startDate, formatter: Date.dateFormatterTime)")
                                    .font(.system(size: 22, weight: .medium))
                            }
                            HStack {
                                Text("Koniec:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(data[index].endDate, formatter: Date.dateFormatterTime)")
                                    .font(.system(size: 22, weight: .medium))
                            }
                            HStack {
                                Text("Dzień:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(data[index].startDate, formatter: Date.dateFormatter)")
                                    .font(.system(size: 22, weight: .medium))
                            }
                        }
                        .padding(16)
                        .background(index % 2 == 0 ? Color.lightGreen : Color.cyan)
                        .cornerRadius(10)
                    }
                } else if !staticData.sleepData.isEmpty {
                    ForEach(staticData.sleepData.indices, id: \.self) { index in
                        VStack(spacing: 5) {
                            HStack {
                                Text("Początek:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(staticData.sleepData[index].startTime, formatter: Date.dateFormatterTime)")
                                    .font(.system(size: 22, weight: .medium))
                            }
                            HStack {
                                Text("Koniec:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(staticData.sleepData[index].endTime, formatter: Date.dateFormatterTime)")
                                    .font(.system(size: 22, weight: .medium))
                            }
                            HStack {
                                Text("Dzień:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(staticData.sleepData[index].date, formatter: Date.dateFormatter)")
                                    .font(.system(size: 22, weight: .medium))
                            }
                            HStack {
                                Text("Czas trwania:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(String(format: "%.1f", staticData.sleepData[index].duration / 3600)) h")
                                    .font(.system(size: 22, weight: .medium))
                            }
                        }
                        .padding(16)
                        .background(index % 2 == 0 ? Color.lightGreen : Color.cyan)
                        .cornerRadius(10)
                    }
                } else {
                    Text("Brak danych o czasie snu.")
                }
            }
        }
        .padding(20)
        .onAppear {
            if !StaticData.staticData.isTestData {
                viewModel.requestSleepData { samples, _ in
                    if let samples = samples {
                        data = samples
                    } else {
                        print("get sleep data error")
                    }
                }
            }
        }
    }
}

struct HealthSleepTimeView_Preview: PreviewProvider {
    static var previews: some View {
        HealthSleepTimeView()
    }
}
