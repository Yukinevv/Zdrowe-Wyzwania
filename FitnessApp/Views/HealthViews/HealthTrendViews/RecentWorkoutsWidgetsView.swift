//
//  RecentWorkoutsWidgetsView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import HealthKit
import SwiftUI

struct RecentWorkoutsWidgetsView: View {
    let workouts: [HKWorkout]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            TitleWorkoutsView(icon: "figure.strengthtraining.functional", title: "Twoje ćwiczenia")
            Text("Trenowałeś \(workouts.count) razy w ciągu ostatnich 7 dni.")
                .font(Font.body.bold())
                .foregroundColor(Color.white)
            if workouts.count >= 5 {
                HStack {
                    Text("Świetna robota!")
                        .foregroundColor(.white)
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                    Spacer().frame(width: 25)
                    Text("Teraz czas na... odpoczynek :)")
                        .foregroundColor(.white)
                    Image(systemName: "bed.double.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                }
            } else if workouts.count >= 2 && workouts.count < 5 {
                HStack {
                    Text("Dobrze Ci idzie.")
                        .foregroundColor(.white)
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                    Spacer().frame(width: 15)
                    Text("Oby tak dalej!")
                        .foregroundColor(.white)
                    Image(systemName: "hand.raised.fingers.spread.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                }
            } else if workouts.count < 2 {
                HStack {
                    Text("Hej, co powiesz na trening?")
                        .foregroundColor(.white)
                    Spacer().frame(width: 15)
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                }
            }
            Divider()
                .background(Color(UIColor.systemGray2))
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 20) {
                    ForEach(workouts.batched(into: 4), id: \.self) { items in
                        ThreeRowWorkoutsView(workouts: items)
                    }
                }
            }
        }
        .cardStyle()
        .frame(maxHeight: Constants.widgetLargeHeight)
    }
}

struct ThreeRowWorkoutsView: View {
    let workouts: [HKWorkout]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(Array(workouts.enumerated()), id: \.offset) { _, element in
                WorkoutRowView(workout: WorkoutRowModel(workout: element))
            }
            Spacer()
        }
    }
}

struct WorkoutRowView: View {
    let workout: WorkoutRowModel

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(workout.imageName)
                .resizable()
                .foregroundColor(Color(UIColor.systemGray))
                .frame(width: 50, height: 50, alignment: .center)
            VStack(alignment: .leading, spacing: -5) {
                Text(workout.activityName)
                    .font(.caption).bold().foregroundColor(Color(UIColor.systemGray))
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(workout.durationHours)")
                            .workoutTitleStyle()
                            + Text(" hr ")
                            .workoutSubheadlineStyle()
                            + Text("\(workout.durationMinutes)")
                            .workoutTitleStyle()
                            + Text(" min")
                            .workoutSubheadlineStyle()
                    }
                    Divider()
                        .background(Color(UIColor.systemGray2))
                    VStack(alignment: .leading, spacing: 5) {
                        Text(workout.energyBurned)
                            .workoutTitleStyle()
                            + Text(" kcal")
                            .workoutSubheadlineStyle()
                    }
                    Divider()
                        .background(Color(UIColor.systemGray2))
                    VStack(alignment: .leading, spacing: 5) {
                        Text(workout.distance)
                            .workoutTitleStyle()
                            + Text(" km")
                            .workoutSubheadlineStyle()
                    }
                }
                .frame(maxHeight: 40)
            }
        }
        .foregroundColor(Color.white)
    }
}

struct RecentWorkoutsWidgetsView_Previews: PreviewProvider {
    static var previews: some View {
        RecentWorkoutsWidgetsView(workouts: HKWorkout.data)
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.dark)
    }
}
