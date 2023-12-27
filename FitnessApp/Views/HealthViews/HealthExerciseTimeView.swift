//
//  HealthExerciseTimeView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 20/06/2023.
//

import HealthKit
import SwiftUI

struct HealthExerciseTimeView: View {
    var viewModel: HealthExerciseTimeViewModel = HealthExerciseTimeViewModel()
    @State var data: [HealthModel] = []

    let calendar = Calendar.current
    let currentDate = StaticData.staticData.getCurrentYearMonthDay()
    let workoutTimeData = StaticData.staticData.workoutTimeData

    @State var staticData: [HealthModel] = []

    var body: some View {
        ScrollView {
            Spacer().frame(height: 90)
            GraphView(data: StaticData.staticData.isTestData ? staticData : data, title: "Suma minut", color: Color.yellow, goal: StaticData.staticData.workoutTimeGoal)
        }
        .onAppear {
            if !StaticData.staticData.isTestData {
                viewModel.requestAuthorization { success in
                    if success {
                        viewModel.requestExerciseTime { data in
                            self.data = data
                        }
                    }
                }
            } else {
                for i in 1 ... 7 {
                    staticData.append(HealthModel(count: Int(workoutTimeData[i - 1] * 60), date: calendar.date(from: DateComponents(year: currentDate.year, month: currentDate.month, day: currentDate.day - i, hour: 12, minute: 0, second: 0)) ?? Date()))
                }
            }
        }
    }
}

struct HealthExerciseTimeView_Previews: PreviewProvider {
    static var previews: some View {
        HealthExerciseTimeView()
    }
}
