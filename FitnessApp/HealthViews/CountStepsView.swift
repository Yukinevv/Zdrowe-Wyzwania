//
//  CountStepsView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 08/05/2023.
//

import HealthKit
import SwiftUI

struct CountStepsView: View {
    private var countSteps = HealthCountSteps()
    @State var steps: [HealthModel] = [HealthModel]()

    var body: some View {
        NavigationView {
            GraphView(data: steps, title: "Suma kroków", color: Color.blue)
        }
        .onAppear {
            countSteps.requestAuthorization { success in
                if success {
                    countSteps.calculateSteps { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            self.steps = countSteps.updateUIFromStatistics(statisticsCollection)
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
