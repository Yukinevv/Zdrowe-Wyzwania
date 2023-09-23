//
//  CaloriesBurnedView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 18/06/2023.
//

import HealthKit
import SwiftUI

struct CaloriesBurnedView: View {
    private var caloriesBurned = HealthCaloriesBurned()
    @State var calories: [HealthModel] = [HealthModel]()

    var body: some View {
        NavigationView {
            GraphView(data: calories, title: "Ilość spalonych kalorii w ostatnim tygodniu", color: Color.orange)
        }
        .onAppear {
            caloriesBurned.requestAuthorization { success in
                if success {
                    caloriesBurned.requestCaloriesBurned { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            self.calories = caloriesBurned.updateUIFromStatistics(statisticsCollection)
                        }
                    }
                }
            }
        }
    }
}

struct CaloriesBurnedView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesBurnedView()
    }
}
