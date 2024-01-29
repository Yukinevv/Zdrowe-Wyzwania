//
//  RecentWorkoutsWidgetsView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import HealthKit
import SwiftUI

struct RecentWorkoutsWidgetsView: View {
    @EnvironmentObject var workoutManager: HealthTrendsViewModel
    @State var workouts: [HKWorkout]
    @State var workoutsToDisplay: [HKWorkout] = []

    let workoutDaysRangeOptions: [Int] = [1, 7, 30]
    @State private var selectedOption = 1

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
                Text("Trenowano dzisiaj \(workoutsToDisplay.count) \(workoutsToDisplay.count == 1 ? "raz" : "razy").")
                    .font(Font.body.bold())
                    .foregroundColor(Color.white)
            } else {
                Text("Trenowano \(workoutsToDisplay.count) \(workoutsToDisplay.count == 1 ? "raz" : "razy") w ciągu ostatnich \(workoutDaysRangeOptions[selectedOption]) dni.")
                    .font(Font.body.bold())
                    .foregroundColor(Color.white)
            }
            if workoutsToDisplay.count >= getWorkoutThresholds(selectedWorkoutDaysRange: selectedOption)[0] {
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
            } else if workoutsToDisplay.count >= getWorkoutThresholds(selectedWorkoutDaysRange: selectedOption)[1]
                && workoutsToDisplay.count < getWorkoutThresholds(selectedWorkoutDaysRange: selectedOption)[0] {
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
            } else if workoutsToDisplay.count < getWorkoutThresholds(selectedWorkoutDaysRange: selectedOption)[1] {
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
                    ForEach(workoutsToDisplay.batched(into: 7), id: \.self) { items in
                        ThreeRowWorkoutsView(workouts: items)
                    }
                }
            }
        }
        .cardStyle()
        .onAppear {
            workoutManager.latestWorkouts { data in
                workouts = data
                assignWorkouts(selectedWorkoutDaysRange: selectedOption)
            }
        }
    }

    /// Przypisuje treningi w zaleznosci od okresu czasowego, w ktorym zostaly wykonane
    ///
    /// - Parameters:
    ///   - selectedWorkoutDaysRange: Wybrany przedzial czasowy
    func assignWorkouts(selectedWorkoutDaysRange: Int) {
        if StaticData.staticData.isTestData {
            switch selectedWorkoutDaysRange {
            case 0:
                workoutsToDisplay = StaticData.staticData.todayWorkouts
                break
            case 1:
                workoutsToDisplay = StaticData.staticData.weekWorkouts
                break
            case 2:
                workoutsToDisplay = StaticData.staticData.monthWorkouts
                break
            default:
                break
            }
        } else {
            let oneDayInSeconds: TimeInterval = 24 * 60 * 60
            let weekInSeconds: TimeInterval = 7 * 24 * 60 * 60
            let monthInSeconds: TimeInterval = 30 * 24 * 60 * 60
            let today = Date()

            switch selectedWorkoutDaysRange {
            case 0:
                let todayWorkouts = workouts.filter { workout in
                    let timeDifference = today.timeIntervalSince(workout.startDate)
                    return timeDifference <= oneDayInSeconds
                }
                workoutsToDisplay = todayWorkouts
                break
            case 1:
                let weekWorkouts = workouts.filter { workout in
                    let timeDifference = today.timeIntervalSince(workout.startDate)
                    return timeDifference <= weekInSeconds
                }
                workoutsToDisplay = weekWorkouts
                break
            case 2:
                let monthWorkouts = workouts.filter { workout in
                    let timeDifference = today.timeIntervalSince(workout.startDate)
                    return timeDifference <= monthInSeconds
                }
                workoutsToDisplay = monthWorkouts
                break
            default:
                break
            }
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
