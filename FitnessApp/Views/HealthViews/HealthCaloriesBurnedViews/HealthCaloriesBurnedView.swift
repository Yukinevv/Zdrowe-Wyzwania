//
//  HealthCaloriesBurnedView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 24/09/2023.
//

import SwiftUI

struct HealthCaloriesBurnedView: View {
    var viewModel: HealthCaloriesBurnedViewModel = HealthCaloriesBurnedViewModel()

    @AppStorage("caloriesGoal") var caloriesGoal: String = ""

    @AppStorage("isDarkMode") private var isDarkMode = true

    var colors: [Color] = [.yellow, .gray, .brown]

    @State var caloriesBurnedArray: [Double] = []

    var body: some View {
        VStack {
            DialView(goal: Int(caloriesGoal) ?? 1000, calories: Int(viewModel.caloriesBurned))
                .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))

            if caloriesBurnedArray.count >= 3 {
                HStack {
                    Text("Ostatnie najlepsze wyniki")
                        .font(.system(size: 20, weight: .semibold))
                        .padding()
                    Spacer()
                }

                HStack(spacing: 30) {
                    StatTile(image: "flame.circle.fill", value: Int(caloriesBurnedArray[1]), measurement: "Kcal",
                             color: colors[1])
                    StatTile(image: "flame.circle.fill", value: Int(caloriesBurnedArray[0]), measurement: "Kcal",
                             color: colors[0])
                    StatTile(image: "flame.circle.fill", value: Int(caloriesBurnedArray[2]), measurement: "Kcal",
                             color: colors[2])
                }
            }
        }
        .padding()
        .navigationTitle("Spalone kalorie")
        .onAppear {
            DispatchQueue.main.async {
                prepareData()
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    func prepareData() {
        for item in viewModel.caloriesBurnedArray {
            caloriesBurnedArray.append(item)
        }
    }
}

struct StatTile: View {
    let image: String
    let value: Int
    let measurement: String
    let color: Color

    @AppStorage("isDarkMode") private var isDarkMode = true

    var body: some View {
        VStack {
            Image(systemName: image)
            Text("\(value)")
                .font(.title)
            Text(measurement)
        }
        .foregroundColor(isDarkMode ? .white : .black)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15).fill(isDarkMode ? .black : .white)
                .shadow(color: .foregroundGray, radius: 3, x: 8, y: 8)
                .shadow(color: color, radius: 3, x: -8, y: -8)
        )
    }
}

struct HealthCaloriesBurnedView_Previews: PreviewProvider {
    static var previews: some View {
        HealthCaloriesBurnedView()
    }
}
