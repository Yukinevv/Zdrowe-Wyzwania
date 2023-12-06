//
//  RecentWorkoutsWidgetsView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import HealthKit
import SwiftUI

struct RecentWorkoutsWidgetsView: View {
    @State var workouts: [HKWorkout]

    let workoutDaysRangeOptions: [Int] = [1, 7, 30]
    @State private var selectedOption = 1

    @State var todayWorkouts: [HKWorkout] = []
    @State var weekWorkouts: [HKWorkout] = []
    @State var monthWorkouts: [HKWorkout] = []

    @State var workoutThresholds: [Int] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            TitleWorkoutsView(icon: "figure.strengthtraining.functional", title: "Twoje ćwiczenia")

            Picker("", selection: $selectedOption) {
                ForEach(workoutDaysRangeOptions.indices, id: \.self) { index in
                    Text("\(index == 0 ? "Dzisiaj" : "\(workoutDaysRangeOptions[index]) \(index == 0 ? "dzień" : "dni")")")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedOption) { newValue in
                assignWorkouts(selectedWorkoutDaysRange: newValue)
            }

            if selectedOption == 0 {
                Text("Trenowano dzisiaj \(workouts.count) \(workouts.count == 1 ? "raz" : "razy").")
                    .font(Font.body.bold())
                    .foregroundColor(Color.white)
            } else {
                Text("Trenowano \(workouts.count) \(workouts.count == 1 ? "raz" : "razy") w ciągu ostatnich \(workoutDaysRangeOptions[selectedOption]) dni.")
                    .font(Font.body.bold())
                    .foregroundColor(Color.white)
            }
            if workouts.count >= getWorkoutThresholds(selectedWorkoutDaysRange: selectedOption)[0] {
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
            } else if workouts.count >= getWorkoutThresholds(selectedWorkoutDaysRange: selectedOption)[1]
                && workouts.count < getWorkoutThresholds(selectedWorkoutDaysRange: selectedOption)[0] {
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
            } else if workouts.count < getWorkoutThresholds(selectedWorkoutDaysRange: selectedOption)[1] {
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
                    ForEach(workouts.batched(into: 7), id: \.self) { items in
                        ThreeRowWorkoutsView(workouts: items)
                    }
                }
            }
        }
        .cardStyle()
        // .frame(maxHeight: Constants.widgetLargeHeight)
        .onAppear {
            if todayWorkouts.isEmpty && weekWorkouts.isEmpty && monthWorkouts.isEmpty {
                let oneDayInSeconds: TimeInterval = 24 * 60 * 60
                let weekInSeconds: TimeInterval = 7 * 24 * 60 * 60
                let monthInSeconds: TimeInterval = 30 * 24 * 60 * 60
                let today = Date()

                todayWorkouts = workouts.filter { workout in
                    let timeDifference = today.timeIntervalSince(workout.startDate)
                    return timeDifference <= oneDayInSeconds
                }
                weekWorkouts = workouts.filter { workout in
                    let timeDifference = today.timeIntervalSince(workout.startDate)
                    return timeDifference <= weekInSeconds
                }
                monthWorkouts = workouts.filter { workout in
                    let timeDifference = today.timeIntervalSince(workout.startDate)
                    return timeDifference <= monthInSeconds
                }

                assignWorkouts(selectedWorkoutDaysRange: selectedOption)
            }
        }
    }

    func assignWorkouts(selectedWorkoutDaysRange: Int) {
        switch selectedWorkoutDaysRange {
        case 0:
            workouts = todayWorkouts
            break
        case 1:
            workouts = weekWorkouts
            break
        case 2:
            workouts = monthWorkouts
            break
        default:
            break
        }
    }

    func getWorkoutThresholds(selectedWorkoutDaysRange: Int) -> [Int] {
        switch selectedWorkoutDaysRange {
        case 0:
            return [1, 1]
        case 1:
            return [5, 2]
        case 2:
            return [14, 6]
        default:
            return [5, 2]
        }
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
//            Image(workout.imageName)
//                .resizable()
//                .foregroundColor(Color(UIColor.systemGray))
//                .frame(width: 50, height: 50, alignment: .center)
            Image(systemName: workout.imageSystemName)
                .resizable()
                .font(Font.body.bold())
                .foregroundColor(.lightGreen)
                .frame(width: 35, height: 35, alignment: .center)
                .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
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
        RecentWorkoutsWidgetsView(workouts: StaticData.staticData.recentWorkoutsData)
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.dark)
    }
}
