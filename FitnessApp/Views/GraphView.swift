//
//  GraphView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 08/05/2023.
//

import SwiftUI

struct GraphView: View {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()

    let steps: [Step]

    var totalSteps: Int {
        steps.map { $0.count }.reduce(0,+)
    }

    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                ForEach(steps, id: \.id) { step in
                    let yValue = Swift.min(step.count / 40, 300)

                    VStack {
                        Text("\(step.count)")
                            .font(.caption)
                        Rectangle()
                            .fill(step.count > 8000 ? Color.green : Color.red)
                            .frame(width: 30, height: CGFloat(yValue))
                        Text("\(step.date, formatter: Self.dateFormatter)")
                            .font(.caption)
                    }
                }
            }

            Text("Suma krokow: \(totalSteps)")
                .padding(.top, 60)
                .font(.system(size: 28, weight: .medium))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(10)
        .padding(10)
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        let steps = [
            Step(count: 5632, date: Date()),
            Step(count: 312, date: Date()),
            Step(count: 1542, date: Date()),
            Step(count: 6342, date: Date()),
            Step(count: 11376, date: Date()),
        ]

        GraphView(steps: steps)
    }
}
