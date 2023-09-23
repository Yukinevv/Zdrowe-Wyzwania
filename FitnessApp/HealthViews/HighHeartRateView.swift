//
//  HeartRateView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 19/06/2023.
//

import HealthKit
import SwiftUI

struct HighHeartRateView: View {
    let dateFormatterTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM hh:mm"
        return formatter
    }()

    @State var data: [HighHeartRate] = []

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
                                Text("\(data[index].heartRate) / min")
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
            self.data = requestHighHeartRate()
        }
    }

    func requestHighHeartRate() -> [HighHeartRate] {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

        let predicate = HKQuery.predicateForQuantitySamples(with: .greaterThan, quantity: HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 120))

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        var highHeartRate: [HighHeartRate] = []

        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            guard let heartRateSamples = samples as? [HKQuantitySample] else {
                return
            }

            for sample in heartRateSamples {
                highHeartRate.append(.init(startDate: sample.startDate, endDate: sample.endDate, heartRate: sample.quantity.doubleValue(for: HKUnit(from: "count/min"))))
            }
        }

        HKHealthStore().execute(query)

        Thread.sleep(forTimeInterval: 0.5)

        return highHeartRate
    }
}

struct HighHeartRateView_Preview: PreviewProvider {
    static var previews: some View {
        HighHeartRateView()
    }
}

struct HighHeartRate: Hashable {
    let startDate: Date
    let endDate: Date
    let heartRate: Double
}
