//
//  WeekWorkoutWidgetView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import HealthKit
import SwiftUI

struct WeekWorkoutsWidgetView: View {
    let weekWorkoutModel: WeekWorkoutModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TitleWorkoutsView(icon: "flame.fill", title: "Treningi")
            Text(weekWorkoutModel.summary)
                .font(Font.body.bold())
                .foregroundColor(Color.white)
            Divider()
                .background(Color(UIColor.systemGray2))
            WeekWorkoutsView(weekWorkoutModel: weekWorkoutModel)
        }
        .cardStyle()
        .frame(maxHeight: Constants.widgetMediumHeight)
    }
}

struct TitleWorkoutsView: View {
    var icon: String
    var title: String

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
            Text(title)
        }
        .font(Font.body.bold())
        .foregroundColor(.lightGreen)
    }
}

struct WeekWorkoutsView: View {
    let weekWorkoutModel: WeekWorkoutModel

    var body: some View {
        HStack {
            ForEach(weekWorkoutModel.workoutDays, id: \.id) {
                WorkoutDayRowView(workoutDayModel: $0)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct WorkoutDayRowView: View {
    var workoutDayModel: WorkoutDayModel

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text(workoutDayModel.day)
                .font(Font.subheadline.bold())
                .foregroundColor(Color(UIColor.systemGray))
            Text("\(workoutDayModel.number)")
                .padding(5)
                .frame(width: 35, height: 35, alignment: .center)
                .background(workoutDayModel.didWorkout ? .lightGreen : Color(UIColor.systemGray2))
                .foregroundColor(workoutDayModel.didWorkout ? Color(UIColor.white) : Color(UIColor.systemGray))
                .clipShape(
                    Circle()
                )
                .if(workoutDayModel.isToday) { view in
                    view.overlay(
                        Circle()
                            .stroke(workoutDayModel.didWorkout ? Color("MainHighlight") : Color(UIColor.systemGray), lineWidth: 4)
                            .padding(1)
                    )
                }
        }
        .lineLimit(1)
        .fixedSize()
    }
}

struct WeekWorkoutsWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeekWorkoutsWidgetView(weekWorkoutModel: WeekWorkoutModel.data)
                .previewDevice("iPhone 15 Pro")
                .preferredColorScheme(.dark)
        }
    }
}
