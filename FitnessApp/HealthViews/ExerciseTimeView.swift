//
//  ExerciseTimeView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 20/06/2023.
//

import HealthKit
import SwiftUI

struct ExerciseTimeView: View {
    let dateFormatterTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM hh:mm:ss"
        return formatter
    }()

    @State var data: [ExerciseTime] = []

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
                                Text("Czas treningu:")
                                    .font(.system(size: 22, weight: .medium))
                                Spacer()
                                Text("\(Int(data[index].time)) min")
                                    .font(.system(size: 22, weight: .medium))
                            }
                        }
                        .padding(16)
                        .background(index % 2 == 0 ? Color.orange : Color.lightGreen)
                        .cornerRadius(10)
                    }
                } else {
                    Text("Brak danych o czasie treningow.")
                }
            }
        }
        .padding(20)
        .onAppear {
            self.data = requestExerciseTime()
        }
    }

    func requestExerciseTime() -> [ExerciseTime] {
        let workoutType = HKObjectType.workoutType()

        let workoutPredicate = HKQuery.predicateForWorkouts(with: .greaterThan, duration: 30)

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        var data: [ExerciseTime] = []

        let query = HKSampleQuery(sampleType: workoutType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in

            if let workoutSamples = samples as? [HKWorkout] {
                for workout in workoutSamples {
                    let duration = workout.duration
                    let durationMinutes = duration / 60.0

                    data.append(.init(startDate: workout.startDate, endDate: workout.endDate, time: durationMinutes))
                }
            }
        }

        HKHealthStore().execute(query)

        Thread.sleep(forTimeInterval: 0.5)

        return data
    }
}

struct ExerciseTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseTimeView()
    }
}

struct ExerciseTime: Hashable {
    let startDate: Date
    let endDate: Date
    let time: Double
}
