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

    var body: some View {
        NavigationView {
            GraphView(data: data, title: "Suma minut", color: Color.blue)
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
