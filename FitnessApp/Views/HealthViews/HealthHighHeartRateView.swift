//
//  HealthHighHeartRateView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 19/06/2023.
//

import HealthKit
import SwiftUI

struct HealthHighHeartRateView: View {
    let dateFormatterTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM hh:mm"
        return formatter
    }()

    var viewModel: HealthHighHeartRateViewModel = HealthHighHeartRateViewModel()

    @State var data: [HKQuantitySample] = []

    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 20)
            VStack(spacing: 15) {
                if !data.isEmpty {
                    ForEach(data.indices, id: \.self) { index in
                        VStack(spacing: 5) {
                            HStack {
                                Text("Poczatek:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(data[index].startDate, formatter: dateFormatterTime)")
                                    .font(.system(size: 22, weight: .medium))
                            }
                            HStack {
                                Text("Koniec:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(data[index].endDate, formatter: dateFormatterTime)")
                                    .font(.system(size: 22, weight: .medium))
                            }
                            HStack {
                                Text("Dzien:")
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
                } else {
                    Text("Brak danych o wysokim tetnie.")
                }
            }
        }
        .padding(20)
        .onAppear {
            DispatchQueue.main.async {
                viewModel.requestAuthorization { success in
                    if success {
                        self.data = viewModel.requestHighHeartRateData()
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
