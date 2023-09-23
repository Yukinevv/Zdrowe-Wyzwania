//
//  SleepTimeView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 18/06/2023.
//

import HealthKit
import SwiftUI

struct SleepTimeView: View {
    let dateFormatterTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        return formatter
    }()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    @State var data: [SleepTime] = []

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
                                Text("\(data[index].sleepDate, formatter: dateFormatter)")
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
            self.data = fetchSleepData()
        }
    }

    func fetchSleepData() -> [SleepTime] {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return []
        }

        let calendar = Calendar.current
        let now = Date()
        let oneWeekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now)!

        let predicate = HKQuery.predicateForSamples(withStart: oneWeekAgo, end: now, options: .strictStartDate)

        var sleepData: [SleepTime] = []

        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            // DispatchQueue.main.async {
            guard let samples = results as? [HKCategorySample], error == nil else {
                return
            }

            for sample in samples {
                sleepData.append(.init(startDate: sample.startDate, endDate: sample.endDate, sleepDate: calendar.startOfDay(for: sample.startDate)))
            }

            // sleepData.append(.init(startDate: Date(), endDate: Date(), sleepDate: Date()))
            // }
        }

        HKHealthStore().execute(query)

        Thread.sleep(forTimeInterval: 0.5)

        return sleepData
    }
}

struct SleepTimeView_Preview: PreviewProvider {
    static var previews: some View {
        SleepTimeView()
    }
}

struct SleepTime: Hashable {
    let startDate: Date
    let endDate: Date
    let sleepDate: Date
}
