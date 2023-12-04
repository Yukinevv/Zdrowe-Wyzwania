//
//  WorkoutWidgetsView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import HealthKit
import SwiftUI

struct WorkoutWidgetsView: View {
    @EnvironmentObject var workoutManager: HealthTrendsViewModel

    let staticData = StaticData.staticData

    var body: some View {
        VStack {
            WeekWorkoutsWidgetView(weekWorkoutModel: staticData.isTestData ? WeekWorkoutModel.data : workoutManager.weekWorkoutModel)
            Spacer().frame(height: 50)
            RecentWorkoutsWidgetsView(workouts: staticData.isTestData ? HKWorkout.data : workoutManager.recentWorkouts)
        }
        .padding()
        .onAppear {
            workoutManager.loadWorkoutData()
        }
    }
}

struct WorkoutWidgetsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutWidgetsView().previewDevice("iPhone 15 Pro").environmentObject(
            HealthTrendsViewModel(
                weekWorkoutModel: WeekWorkoutModel.data,
                recentWorkouts: HKWorkout.data
            )
        )
    }
}
