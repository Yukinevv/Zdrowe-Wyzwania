//
//  HealthSettingsView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 04/10/2023.
//

import SwiftUI

struct HealthSettingsView: View {
    let staticData = StaticData.staticData

    var body: some View {
        VStack {
            // Spacer()
            HStack {
                Toggle("Kroki", isOn: staticData.$stepsCardVisibility)
                    .padding()
                Spacer()
                TextField("Kroki", text: staticData.$stepsGoalString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Toggle("Kalorie", isOn: staticData.$caloriesCardVisibility)
                    .padding()
                Spacer()
                TextField("Kalorie", text: staticData.$caloriesGoalString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Toggle("Sen", isOn: staticData.$sleepCardVisibility)
                    .padding()
                Spacer()
                TextField("Sen", text: staticData.$sleepGoalString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Toggle("Nawodnienie", isOn: staticData.$waterCardVisibility)
                    .padding()
                Spacer()
                TextField("Nawodnienie", text: staticData.$waterGoalString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Toggle("Tętno", isOn: staticData.$heartRateCardVisibility)
                    .padding()
                Spacer()
                TextField("Tętno", text: staticData.$heartRateGoalString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Toggle("Czas treningu", isOn: staticData.$workoutTimeCardVisibility)
                    .padding()
                Spacer()
                TextField("Czas treningu", text: staticData.$workoutTimeGoalString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Spacer()

            Toggle("Dane testowe", isOn: staticData.$isTestData)
                .padding()
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
