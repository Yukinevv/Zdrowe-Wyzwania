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
    @State var cardsVisibility: [Bool] = [true, true, true, true, true, true]

    let staticData = StaticData.staticData

    @State var statsData: [Stats] = []

    var healthData: HealthCardsViewModel = HealthCardsViewModel()

    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 30) {
            ForEach(0 ..< statsData.count, id: \.self) { index in
                if cardsVisibility[index] {
                    HealthCardView(stats: statsData[index])
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
            staticData.stepsCardVisibility,
            staticData.caloriesCardVisibility,
            staticData.sleepCardVisibility,
            staticData.waterCardVisibility,
            staticData.heartRateCardVisibility,
            staticData.workoutTimeCardVisibility,
        ]
    }

    func updateStatsData() {
        statsData = [
            Stats(id: 0, title: "Kroki", currentData: staticData.isTestData ? staticData.stepsData[0] : healthData.stepCount, goal: staticData.stepsGoal, color: Color("steps"), showModal: false),
            Stats(id: 1, title: "Kalorie", currentData: staticData.isTestData ? staticData.caloriesData[0] : healthData.caloriesBurned, goal: staticData.caloriesGoal, color: Color("Main"), showModal: false),
            Stats(id: 2, title: "Sen", currentData: staticData.isTestData ? round((staticData.sleepData[0].duration / 3600) * 10) / 10 : healthData.sleepData, goal: staticData.sleepGoal, color: Color("sleep"), showModal: false),
            Stats(id: 3, title: "Nawodnienie", currentData: staticData.isTestData ? staticData.waterData[0] : healthData.waterAmount, goal: staticData.waterGoal, color: Color("water"), showModal: false),
            Stats(id: 4, title: "Tętno", currentData: staticData.isTestData ? Double(staticData.heartRateData[0].highHeartRate) : healthData.highHeartRateValue, goal: staticData.heartRateGoal, color: Color("running"), showModal: false),
            Stats(id: 5, title: "Czas treningu", currentData: staticData.isTestData ? staticData.workoutTimeData[0] : healthData.workoutTime, goal: staticData.workoutTimeGoal, color: Color("cycle"), showModal: false),
        ]
    }
}

struct HealthCardsView_Previews: PreviewProvider {
    static var previews: some View {
        HealthCardsView().preferredColorScheme(.dark)
    }
}
