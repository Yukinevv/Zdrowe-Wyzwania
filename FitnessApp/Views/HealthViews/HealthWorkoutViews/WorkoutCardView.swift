//
//  WorkoutCardView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 23/09/2023.
//

import SwiftUI

struct WorkoutCardView: View {
    @State var activity: WorkoutModel

    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(15)

            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(activity.title)
                            .font(.system(size: 16))

                        Text(activity.subtitle)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Image(systemName: activity.image)
                        .foregroundColor(activity.tintColor)
                }

                Text(activity.amount)
                    .font(.system(size: 24))
                    .minimumScaleFactor(0.6)
                    .bold()
                    .padding(.bottom)
            }
            .padding()
        }
    }
}

struct WorkoutCardView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCardView(activity: WorkoutModel(id: 0, title: "Daily steps", subtitle: "Goal: 10,000", image: "figure.walk", tintColor: .green, amount: "6,545"))
    }
}
