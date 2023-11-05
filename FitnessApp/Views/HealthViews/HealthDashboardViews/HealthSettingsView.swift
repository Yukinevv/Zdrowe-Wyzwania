//
//  HealthSettingsView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 04/10/2023.
//

import SwiftUI

struct HealthSettingsView: View {
    @AppStorage("stepsCardVisibility") var stepsCardVisibility: Bool = true
    @AppStorage("caloriesCardVisibility") var caloriesCardVisibility: Bool = true
    @AppStorage("sleepCardVisibility") var sleepCardVisibility: Bool = true
    @AppStorage("waterCardVisibility") var waterCardVisibility: Bool = true
    @AppStorage("heartRateCardVisibility") var heartRateCardVisibility: Bool = true
    @AppStorage("workoutTimeCardVisibility") var workoutTimeCardVisibility: Bool = true

    @AppStorage("stepsGoal") var stepsGoalString: String = ""
    @AppStorage("caloriesGoal") var caloriesGoalString: String = ""
    @AppStorage("sleepGoal") var sleepGoalString: String = ""
    @AppStorage("waterGoal") var waterGoalString: String = ""
    @AppStorage("heartRateGoal") var heartRateGoalString: String = ""
    @AppStorage("workoutTimeGoal") var workoutTimeGoalString: String = ""

    var body: some View {
        VStack {
            // Spacer()
            HStack {
                Toggle("Kroki", isOn: $stepsCardVisibility)
                    .padding()
                Spacer()
                TextField("Kroki", text: $stepsGoalString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Toggle("Kalorie", isOn: $caloriesCardVisibility)
                    .padding()
                Spacer()
                TextField("Kalorie", text: $caloriesGoalString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Toggle("Sen", isOn: $sleepCardVisibility)
                    .padding()
                Spacer()
                TextField("Sen", text: $sleepGoalString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Toggle("Nawodnienie", isOn: $waterCardVisibility)
                    .padding()
                Spacer()
                TextField("Nawodnienie", text: $waterGoalString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Toggle("Tętno", isOn: $heartRateCardVisibility)
                    .padding()
                Spacer()
                TextField("Tętno", text: $heartRateGoalString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Toggle("Czas treningu", isOn: $workoutTimeCardVisibility)
                    .padding()
                Spacer()
                TextField("Czas treningu", text: $workoutTimeGoalString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Ustawienia")
    }
}

struct HealthSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HealthSettingsView().preferredColorScheme(.dark)
    }
}
