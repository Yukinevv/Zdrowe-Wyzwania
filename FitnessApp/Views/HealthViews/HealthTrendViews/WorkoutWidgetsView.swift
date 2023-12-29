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
        VStack(spacing: 20) {
            WeekWorkoutsWidgetView(weekWorkoutModel: staticData.isTestData ? WeekWorkoutModel.data : workoutManager.weekWorkoutModel)
            RecentWorkoutsWidgetsView(workouts: staticData.isTestData ? StaticData.staticData.recentWorkoutsData : workoutManager.recentWorkouts).environmentObject(workoutManager)
        }
        .padding()
    }
}

struct WorkoutWidgetsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutWidgetsView().previewDevice("iPhone 15 Pro").environmentObject(
            HealthTrendsViewModel(
                weekWorkoutModel: WeekWorkoutModel.data,
                recentWorkouts: StaticData.staticData.recentWorkoutsData // HKWorkout.data
            )
        )
    }
}
