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

    var body: some View {
        VStack {
            WeekWorkoutsWidgetView(weekWorkoutModel: workoutManager.weekWorkoutModel)
            Spacer().frame(height: 50)
            // RecentWorkoutsWidgetsView(workouts: workoutManager.recentWorkouts)
            RecentWorkoutsWidgetsView(workouts: HKWorkout.data)
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
