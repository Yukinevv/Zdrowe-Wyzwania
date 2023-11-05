//
//  HealthCardsView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 14/10/2023.
//

import SwiftUI

struct Stats: Identifiable {
    var id: Int
    var title: String
    var currentData: CGFloat
    var goal: CGFloat
    var color: Color
    var showModal: Bool
}

struct HealthCardsView: View {
    @AppStorage("stepsCardVisibility") var stepsCardVisibility: Bool = true
    @AppStorage("caloriesCardVisibility") var caloriesCardVisibility: Bool = true
    @AppStorage("sleepCardVisibility") var sleepCardVisibility: Bool = true
    @AppStorage("waterCardVisibility") var waterCardVisibility: Bool = true
    @AppStorage("heartRateCardVisibility") var heartRateCardVisibility: Bool = true
    @AppStorage("workoutTimeCardVisibility") var workoutTimeCardVisibility: Bool = true

    @State var cardsVisibility: [Bool] = [true, true, true, true, true, true]

    @AppStorage("stepsGoal") var stepsGoal: String = ""
    @AppStorage("caloriesGoal") var caloriesGoal: String = ""
    @AppStorage("sleepGoal") var sleepGoal: String = ""
    @AppStorage("waterGoal") var waterGoal: String = ""
    @AppStorage("heartRateGoal") var heartRateGoal: String = ""
    @AppStorage("workoutTimeGoal") var workoutTimeGoal: String = ""

    var statsStaticData = [
        Stats(id: 0, title: "Kroki", currentData: 8429, goal: 10000, color: Color("steps"), showModal: false),
        Stats(id: 1, title: "Kalorie", currentData: 360, goal: 500, color: Color("Main"), showModal: false),
        Stats(id: 2, title: "Sen", currentData: 7.2, goal: 8, color: Color("sleep"), showModal: false),
        Stats(id: 3, title: "Nawodnienie", currentData: 3.5, goal: 5, color: Color("water"), showModal: false),
        Stats(id: 4, title: "Tętno", currentData: 115, goal: 100, color: Color("running"), showModal: false),
        Stats(id: 5, title: "Czas treningu", currentData: 0.7, goal: 30, color: Color("cycle"), showModal: false),
    ]

    @State var statsData: [Stats] = []

    var healthData: HealthCardsViewModel = HealthCardsViewModel()

    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 30) {
            ForEach(0 ..< statsStaticData.count, id: \.self) { index in
                if cardsVisibility[index] {
                    HealthCardView(stats: statsStaticData[index])
                }
            }
        }
        .padding(.horizontal, 8)
        .onAppear {
            DispatchQueue.main.async {
                updateCardsVisibility()
                // print("update widocznosci kart")
                updateStatsData()
                // print("update wartosci kart")
            }
        }
    }

    func updateCardsVisibility() {
        cardsVisibility = [
            stepsCardVisibility,
            caloriesCardVisibility,
            sleepCardVisibility,
            waterCardVisibility,
            heartRateCardVisibility,
            workoutTimeCardVisibility,
        ]
    }

    func updateStatsData() {
        let stepsGoal = Double(self.stepsGoal) ?? 10000
        let caloriesGoal = Double(self.caloriesGoal) ?? 500
        let sleepGoal = Double(self.sleepGoal) ?? 8
        let waterGoal = Double(self.waterGoal) ?? 5
        let heartRateGoal = Double(self.heartRateGoal) ?? 100
        let workoutTimeGoal = Double(self.workoutTimeGoal) ?? 30

        statsData = [
            Stats(id: 0, title: "Kroki", currentData: healthData.stepCount, goal: stepsGoal, color: Color("steps"), showModal: false),
            Stats(id: 1, title: "Kalorie", currentData: healthData.caloriesBurned, goal: caloriesGoal, color: Color("Main"), showModal: false),
            Stats(id: 2, title: "Sen", currentData: healthData.sleepData, goal: sleepGoal, color: Color("sleep"), showModal: false),
            Stats(id: 3, title: "Nawodnienie", currentData: healthData.waterAmount, goal: waterGoal, color: Color("water"), showModal: false),
            Stats(id: 4, title: "Tętno", currentData: healthData.highHeartRateValue, goal: heartRateGoal, color: Color("running"), showModal: false),
            Stats(id: 5, title: "Czas treningu", currentData: healthData.workoutTime, goal: workoutTimeGoal, color: Color("cycle"), showModal: false),
        ]
    }
}

struct HealthCardsView_Previews: PreviewProvider {
    static var previews: some View {
        HealthCardsView().preferredColorScheme(.dark)
    }
}
