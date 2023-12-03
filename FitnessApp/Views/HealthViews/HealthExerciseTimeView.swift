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
    @State var data: [HealthModel] = [HealthModel]()

    var staticData = [
        HealthModel(count: 35, date: Date()),
        HealthModel(count: 40, date: Date()),
        HealthModel(count: 60, date: Date()),
        HealthModel(count: 110, date: Date()),
        HealthModel(count: 45, date: Date()),
    ]

    var body: some View {
        NavigationView {
            GraphView(data: staticData, title: "Suma minut", color: Color.blue)
        }
        .onAppear {
            viewModel.requestAuthorization { success in
                if success {
                    self.data = viewModel.requestExerciseTime()
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
