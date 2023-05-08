//
//  CountStepsView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 08/05/2023.
//

import HealthKit
import SwiftUI

struct CountStepsView: View {
    @StateObject private var viewModel = CountStepsViewModel()

    var body: some View {
        NavigationView {
            GraphView(steps: viewModel.steps)
                .navigationTitle("Zdrowie")
        }
        .onAppear {
            viewModel.requestAuthorization { success in
                if success {
                    viewModel.calculateSteps { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            viewModel.updateUIFromStatistics(statisticsCollection)
                        }
                    }
                }
            }
        }
    }
}

struct CountStepsView_Previews: PreviewProvider {
    static var previews: some View {
        CountStepsView()
    }
}
