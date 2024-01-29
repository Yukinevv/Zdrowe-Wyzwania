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
            HStack {
                Toggle("Kroki", isOn: staticData.$stepsCardVisibility)
                    .padding()
                Spacer()
                VStack {
                    Text("Cel").font(.system(size: 18, weight: .medium))
                    TextField("Kroki", text: Binding(
                        get: { staticData.stepsGoalString },
                        set: { newValue in
                            validateAndAssign(newValue: newValue, type: "steps")
                        }
                    ))
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                }
            }
            HStack {
                Toggle("Kalorie", isOn: staticData.$caloriesCardVisibility)
                    .padding()
                Spacer()
                TextField("Kalorie", text: Binding(
                    get: { staticData.caloriesGoalString },
                    set: { newValue in
                        validateAndAssign(newValue: newValue, type: "calories")
                    }
                ))
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            }
            HStack {
                Toggle("Sen", isOn: staticData.$sleepCardVisibility)
                    .padding()
                Spacer()
                TextField("Sen", text: Binding(
                    get: { staticData.sleepGoalString },
                    set: { newValue in
                        validateAndAssign(newValue: newValue, type: "sleep")
                    }
                ))
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            }
            HStack {
                Toggle("Nawodnienie", isOn: staticData.$waterCardVisibility)
                    .padding()
                Spacer()
                TextField("Nawodnienie", text: Binding(
                    get: { staticData.waterGoalString },
                    set: { newValue in
                        validateAndAssign(newValue: newValue, type: "water")
                    }
                ))
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            }
            HStack {
                Toggle("Tętno", isOn: staticData.$heartRateCardVisibility)
                    .padding()
                Spacer()
                TextField("Tętno", text: Binding(
                    get: { staticData.heartRateGoalString },
                    set: { newValue in
                        validateAndAssign(newValue: newValue, type: "heartRate")
                    }
                ))
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            }
            HStack {
                Toggle("Czas treningu", isOn: staticData.$workoutTimeCardVisibility)
                    .padding()
                Spacer()
                TextField("Czas treningu", text: Binding(
                    get: { staticData.workoutTimeGoalString },
                    set: { newValue in
                        validateAndAssign(newValue: newValue, type: "workoutTime")
                    }
                ))
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            }
            Spacer()

            Rectangle().fill(.gray).frame(height: 2).padding()

            Toggle("Dane testowe", isOn: staticData.$isTestData)
                .padding()
            Spacer()
        }
        .padding()
        .navigationTitle("Ustawienia")
    }

    /// Sprawdza poprawnosc wprowadzanych celow wybranych aktywnosci
    ///
    /// - Parameters:
    ///   - newValue: Nowa wartosc celu
    ///   - type: Rodzaj celu
    private func validateAndAssign(newValue: String, type: String) {
        switch type {
        case "steps":
            if let number = Int(newValue), number >= 0 {
                staticData.stepsGoalString = newValue
            } else {
                staticData.stepsGoalString = "10000"
            }
        case "calories":
            if let number = Int(newValue), number >= 0 {
                staticData.caloriesGoalString = newValue
            } else {
                staticData.caloriesGoalString = "500"
            }
        case "sleep":
            if let number = Int(newValue), number >= 0 {
                staticData.sleepGoalString = newValue
            } else {
                staticData.sleepGoalString = "8"
            }
        case "water":
            if let number = Int(newValue), number >= 0 {
                staticData.waterGoalString = newValue
            } else {
                staticData.waterGoalString = "5"
            }
        case "heartRate":
            if let number = Int(newValue), number >= 0 {
                staticData.heartRateGoalString = newValue
            } else {
                staticData.heartRateGoalString = "120"
            }
        case "workoutTime":
            if let number = Int(newValue), number >= 0 {
                staticData.workoutTimeGoalString = newValue
            } else {
                staticData.workoutTimeGoalString = "30"
            }
        default:
            break
        }
    }
}

struct HealthSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HealthSettingsView().preferredColorScheme(.dark)
    }
}
