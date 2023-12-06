//
//  DialView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 24/09/2023.
//

import Foundation
import SwiftUI

struct DialView: View {
    let goal: Int
    let calories: Int

    var body: some View {
        ZStack {
            SpokesView()
                .padding(10)
            CircleView()

            ZStack {
                CircleView()

                Circle().stroke(style: StrokeStyle(lineWidth: 12))
                    .padding(20)
                    .foregroundColor(.foregroundGray)

                Circle()
                    .trim(from: 0, to: CGFloat(calories) / CGFloat(goal))
                    .scale(x: -1)
                    .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .butt))
                    .padding(20)
                    .foregroundColor(Color("Main"))
                    .rotationEffect(.init(degrees: -48))

                VStack {
                    Text("Cel: \(goal)")
                    Text("\(calories)")
                        .font(.system(size: 42, weight: .bold))
                        .padding()
                    Text("Dobrze Ci idzie!")
                }
            }
            .padding()
        }
        .foregroundColor(StaticData.staticData.isDarkMode ? .white : .black)
    }
}

struct DialView_Previews: PreviewProvider {
    static var previews: some View {
        DialView(goal: 500, calories: 305).preferredColorScheme(.dark)
    }
}
