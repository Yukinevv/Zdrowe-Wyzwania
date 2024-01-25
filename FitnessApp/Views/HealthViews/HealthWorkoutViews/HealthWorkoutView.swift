//
//  HealthWorkoutView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 24/09/2023.
//

import SwiftUI

struct HealthWorkoutView: View {
    @ObservedObject var viewModel: HealthWorkoutViewModel = HealthWorkoutViewModel()
    let welcomeArray = ["Twoje statystyki treningowe", "Jaki trening na dziś planujesz?", "Nie zatrzymuj się. Tak trzymaj!"]
    @State private var currentIndex = 0

    let staticData = StaticData.staticData
    @State var mockActivities: [WorkoutModel] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(welcomeArray[currentIndex])
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.secondary)
                    .animation(.easeInOut(duration: 1), value: currentIndex)
                    .onAppear {
                        currentIndex = Int.random(in: 0 ... 2)
                    }

                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                    if !staticData.isTestData {
                        ForEach(viewModel.activites.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                            WorkoutCardView(activity: item.value)
                        }
                    } else {
                        ForEach(mockActivities, id: \.self) { item in
                            WorkoutCardView(activity: item)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            if staticData.isTestData {
                self.updateMockActivities()
                print("test updateMock")
            }
        }
    }

    func updateMockActivities() {
        mockActivities = [
            WorkoutModel(id: 0, title: "Kroki", subtitle: "Cel \(Int(staticData.stepsGoalString) ?? 10000)", image: "figure.walk", tintColor: .green, amount: String(Int(staticData.stepsData[0]))),
            WorkoutModel(id: 1, title: "Kalorie", subtitle: "Cel \(Int(staticData.caloriesGoalString) ?? 500)", image: "flame", tintColor: .red, amount: String(Int(staticData.caloriesData[0])) + " kcal"),
            WorkoutModel(id: 2, title: "Bieganie", subtitle: "Obecny tydzień", image: "figure.run", tintColor: .orange, amount: String(staticData.runningData) + " min"),
            WorkoutModel(id: 3, title: "Trening siłowy", subtitle: "Obecny tydzień", image: "dumbbell", tintColor: .cyan, amount: String(staticData.strengthTrainingData) + " min"),
            WorkoutModel(id: 4, title: "Pływanie", subtitle: "Obecny tydzień", image: "figure.pool.swim", tintColor: .blue, amount: String(staticData.swimmingData) + " min"),
            WorkoutModel(id: 5, title: "Piłka nożna", subtitle: "Obecny tydzień", image: "figure.soccer", tintColor: .green, amount: String(staticData.footballData) + " min"),
            WorkoutModel(id: 6, title: "Koszykówka", subtitle: "Obecny tydzień", image: "figure.basketball", tintColor: .orange, amount: String(staticData.basketballData) + " min"),
            WorkoutModel(id: 7, title: "Orbitrek", subtitle: "Obecny tydzień", image: "figure.stair.stepper", tintColor: .cyan, amount: String(staticData.stairStepperData) + " min"),
        ]
    }
}

struct HealthWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        HealthWorkoutView()
    }
}
