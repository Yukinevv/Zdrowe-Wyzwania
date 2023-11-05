//
//  HealthTrendsView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import SwiftUI

struct HealthTrendsView: View {
    @State private var showingAlert = false
    @State private var errorMesage = ""

    @StateObject var workoutManager = HealthTrendsViewModel()

    var body: some View {
        ScrollView {
            WorkoutWidgetsView()
                .environmentObject(workoutManager)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Coś poszło nie tak..."), message: Text(errorMesage), dismissButton: .default(Text("Ok")))
        }
        .onAppear {
            workoutManager.requestAuthorization {
                workoutManager.loadWorkoutData()
            } onError: { error in
                if let error = error {
                    errorMesage = error.localizedDescription
                }
                showingAlert = true
            }
        }
        .navigationTitle("Trendy")
    }
}

struct HealthTrendsView_Previews: PreviewProvider {
    static var previews: some View {
        HealthTrendsView()
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.dark)
    }
}
