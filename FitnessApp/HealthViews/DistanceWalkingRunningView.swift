//
//  DistanceWalkingRunningView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 19/06/2023.
//

import HealthKit
import SwiftUI

struct DistanceWalkingRunningView: View {
    private var distanceWalkingRunning = HealthDistanceWalkingRunning()
    @State var distance: [HealthModel] = [HealthModel]()

    var body: some View {
        NavigationView {
            GraphView(data: distance, title: "Przebyty dystans w ostatnim tygodniu", color: Color.green, multiplyer: 20)
        }
        .onAppear {
            distanceWalkingRunning.requestAuthorization { success in
                if success {
                    distanceWalkingRunning.requestDistanceWalkingRunning { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            self.distance = distanceWalkingRunning.updateUIFromStatistics(statisticsCollection)
                        }
                    }
                }
            }
        }
    }
}

struct DistanceWalkingRunningView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceWalkingRunningView()
    }
}
