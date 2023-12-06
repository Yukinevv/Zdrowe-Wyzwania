//
//  HealthHighHeartRateView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 19/06/2023.
//

import HealthKit
import SwiftUI

struct HealthHighHeartRateView: View {
    var viewModel: HealthHighHeartRateViewModel = HealthHighHeartRateViewModel()

    @State var data: [HKQuantitySample] = []

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
                                Text("Tętno:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(data[index].quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))) / min")
                                    .font(.system(size: 22, weight: .medium))
                            }
                        }
                        .padding(16)
                        .background(index % 2 == 0 ? Color.orange : Color.red)
                        .cornerRadius(10)
                    }
                } else if !staticData.heartRateData.isEmpty {
                    ForEach(staticData.heartRateData.indices, id: \.self) { index in
                        VStack(spacing: 5) {
                            HStack {
                                Text("Początek:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(staticData.heartRateData[index].startTime, formatter: Date.dateFormatterTime)")
                                    .font(.system(size: 22, weight: .medium))
                            }
                            HStack {
                                Text("Koniec:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(staticData.heartRateData[index].endTime, formatter: Date.dateFormatterTime)")
                                    .font(.system(size: 22, weight: .medium))
                            }
                            HStack {
                                Text("Dzień:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(staticData.heartRateData[index].date, formatter: Date.dateFormatter)")
                                    .font(.system(size: 22, weight: .medium))
                            }
                            HStack {
                                Text("Tętno:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(staticData.heartRateData[index].highHeartRate) ud / min")
                                    .font(.system(size: 22, weight: .medium))
                            }
                        }
                        .padding(16)
                        .background(index % 2 == 0 ? Color.orange : Color.red)
                        .cornerRadius(10)
                    }
                } else {
                    Text("Brak danych o wysokim tętnie.")
                }
            }
        }
        .padding(20)
        .onAppear {
            DispatchQueue.main.async {
                if !staticData.isTestData {
                    viewModel.requestAuthorization { success in
                        if success {
                            self.data = viewModel.requestHighHeartRateData()
                        }
                    }
                }
            }
        }
    }
}

struct HealthHighHeartRateView_Preview: PreviewProvider {
    static var previews: some View {
        HealthHighHeartRateView()
    }
}
