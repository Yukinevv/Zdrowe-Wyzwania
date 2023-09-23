//
//  GraphView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 08/05/2023.
//

import SwiftUI

struct GraphView: View {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()

    var data: [HealthModel]

    var title: String

    var color: Color

    var multiplyer: CGFloat?

    var totalData: Int {
        data.map { $0.count }.reduce(0,+)
    }

    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                ForEach(self.data, id: \.id) { value in
                    let yValue = Swift.min((value.count / 40 >= 1 ? value.count / 40 : value.count), 300)

                    VStack {
                        Text("\(value.count)")
                            .font(.caption)

                        Rectangle()
                            .fill(value.count > 8000 ? Color.green : color)
                            .frame(width: 30, height: CGFloat(yValue) * (multiplyer ?? 1.0))

                        Text("\(value.date, formatter: dateFormatter)")
                            .font(.caption)
                    }
                }
            }

            Text("\(self.title): \(self.totalData)")
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
        let data = [
            HealthModel(count: 5632, date: Date()),
            HealthModel(count: 312, date: Date()),
            HealthModel(count: 1542, date: Date()),
            HealthModel(count: 6342, date: Date()),
            HealthModel(count: 11376, date: Date()),
        ]

        GraphView(data: data, title: "Suma krokow", color: Color.red)
    }
}
