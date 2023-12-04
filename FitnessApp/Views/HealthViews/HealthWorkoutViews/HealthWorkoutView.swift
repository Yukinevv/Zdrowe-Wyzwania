//
//  HealthWorkoutView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 24/09/2023.
//

import SwiftUI

struct HealthWorkoutView: View {
    @EnvironmentObject var manager: HealthWorkoutViewModel
    let welcomeArray = ["Twoje statystyki treningowe", "Jaki trening na dziś planujesz?", "Nie zatrzymuj się. Tak trzymaj!"]
    @State private var currentIndex = 0

    var body: some View {
        VStack(alignment: .leading) {
            Text(welcomeArray[currentIndex])
                .font(.largeTitle)
                .padding()
                .foregroundColor(.secondary)
                .animation(.easeInOut(duration: 1), value: currentIndex)
                .onAppear {
                    startWelcomeTimer()
                }

            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                ForEach((StaticData.staticData.isTestData ? manager.mockActivities : manager.activites).sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                    WorkoutCardView(activity: item.value)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    func startWelcomeTimer() {
        Timer.scheduledTimer(withTimeInterval: 7, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % welcomeArray.count
            }
        }
    }
}

struct HealthWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        HealthWorkoutView()
            .environmentObject(HealthWorkoutViewModel())
    }
}
