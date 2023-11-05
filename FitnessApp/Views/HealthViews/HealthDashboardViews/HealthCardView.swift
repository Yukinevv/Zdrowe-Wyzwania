//
//  HealthCardView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 15/10/2023.
//

import SwiftUI

struct HealthCardView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    @State var stats: Stats
    @State var currentData: Double = 0.0

    var healthCardViewModel: HealthCardViewModel = HealthCardViewModel()

    var body: some View {
        VStack(spacing: 22) {
            VStack {
                HStack {
                    Text(stats.title)
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(Color(.white))

                    Spacer(minLength: 0)
                }
                HStack {
                    Text("\(stats.title == "Tętno" ? "Próg" : "Cel"): \(Int(stats.goal)) \(stats.title == "Sen" ? "h" : healthCardViewModel.getType(title: stats.title))")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.white))

                    Spacer(minLength: 0)
                }
            }

            // Ring
            ZStack {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(stats.color.opacity(0.25), lineWidth: 10)
                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                Circle()
                    .trim(from: 0, to: healthCardViewModel.getValue(currentData, title: stats.title) / stats.goal)
                    .stroke(stats.color, style: StrokeStyle(lineWidth: 10, lineCap: .butt))
                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                Text(healthCardViewModel.getPercent(current: healthCardViewModel.getValue(stats.currentData, title: stats.title), goal: stats.goal) + " %")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(stats.color)
                    // Rotates the bar so it begins at 12'clock
                    .rotationEffect(.init(degrees: 90))
            }
            // Fixes rotation on all elements in HStack
            .rotationEffect(.init(degrees: -90))

            Text(healthCardViewModel.getValueForPrint(value: stats.currentData, title: stats.title) + " " + healthCardViewModel.getType(title: stats.title))
                .lineLimit(1)
                .font(.system(size: 22))
                .foregroundColor(Color(.white))
                .fontWeight(.bold)
                .shadow(color: Color(.white).opacity(0.2), radius: 10, x: 0, y: 0)
        }
        .padding()
        .background(Color(.white).opacity(0.06))
        .cornerRadius(15)
        .shadow(color: Color(.white).opacity(0.2), radius: 10, x: 0, y: 0)
        .onAppear {
            stats.goal = healthCardViewModel.updateStatsGoalData(goal: stats.goal, title: stats.title)
            withAnimation(.spring(response: 4)) {
                currentData = stats.currentData
            }
        }
        .onTapGesture {
            stats.showModal = true
        }
        .sheet(isPresented: $stats.showModal) {
            NavigationView {
                healthCardViewModel.getHealthView(for: stats.title, value: currentData)
                    .navigationTitle(stats.title)
            }.preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

struct HealthCardView_Previews: PreviewProvider {
    static var previews: some View {
        HealthCardView(stats: Stats(id: 0, title: "Kroki", currentData: 16889, goal: 20000, color: Color("steps"), showModal: false)).preferredColorScheme(.dark)
    }
}
