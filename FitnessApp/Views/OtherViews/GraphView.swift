//
//  GraphView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 08/05/2023.
//

import SwiftUI

struct GraphView: View {
    var data: [HealthModel]

    var title: String

    var color: Color

    var goal: Double

    var multiplyer: CGFloat?

    var totalData: Int {
        data.map { $0.count }.reduce(0,+)
    }

    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                ForEach(self.data, id: \.id) { value in
                    let yValue = Swift.min(value.count, 100)

                    VStack {
                        Text("\(value.count)")
                            .font(.caption)

                        Rectangle()
                            .fill(value.count > Int(self.goal) ? Color.green : self.color)
                            .frame(width: 40, height: CGFloat(yValue) * (multiplyer ?? 5.0))

                        Text("\(value.date, formatter: Date.dateWithoutYearFormatter)")
                            .font(.caption)
                    }
                }
            }

            Text("\(self.title): \(self.totalData)")
                .padding(.top, 40)
                .font(.system(size: 28, weight: .medium))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(10)
        .padding(10)
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        let data = [
            HealthModel(count: 6632, date: Date()),
            HealthModel(count: 312, date: Date()),
            HealthModel(count: 1542, date: Date()),
            HealthModel(count: 4347, date: Date()),
            HealthModel(count: 10376, date: Date()),
        ]

        GraphView(data: data, title: "Suma kroków", color: Color.red, goal: 6000)
    }
}
