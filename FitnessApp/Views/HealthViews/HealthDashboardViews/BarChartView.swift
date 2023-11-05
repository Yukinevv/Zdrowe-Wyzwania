//
//  BarChartView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 14/10/2023.
//

import SwiftUI

struct Daily: Identifiable {
    var id: Int
    var day: String
    var workout_In_Min: CGFloat
}

struct BarChartView: View {
    @Binding var selected: Int
    var backgrnd = [Color.white.opacity(0.06)]
    var colors = [Color("Color1"), Color("Color")]

    var workoutStaticData = [
        Daily(id: 0, day: "Dzień 1", workout_In_Min: 60),
        Daily(id: 1, day: "Dzień 2", workout_In_Min: 100),
        Daily(id: 2, day: "Dzień 3", workout_In_Min: 120),
        Daily(id: 3, day: "Dzień 4", workout_In_Min: 80),
        Daily(id: 4, day: "Dzień 5", workout_In_Min: 180),
        Daily(id: 5, day: "Dzień 6", workout_In_Min: 115),
        Daily(id: 6, day: "Dzień 7", workout_In_Min: 75),
    ]

    var viewModel: HealthExerciseTimeViewModel = HealthExerciseTimeViewModel()
    @State var data: [HealthModel] = [HealthModel]()

    @State var workoutData: [Daily] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text("Codzienne treningi")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .foregroundColor(.white)

            HStack(spacing: 15) {
                ForEach(workoutStaticData) { work in
                    VStack {
                        VStack {
                            Spacer(minLength: 0)

                            if selected == work.id {
                                Text(getHrs(value: work.workout_In_Min))
                                    .foregroundColor(Color("Color"))
                                    .padding(.bottom)
                            }
                            // Gradient Bars
                            RoundedShape()
                                .fill(LinearGradient(gradient: .init(colors: selected == work.id ? colors : backgrnd), startPoint: .top, endPoint: .bottom))
                                .frame(height: getHeight(value: (work.workout_In_Min) * 3))
                        }
                        .frame(height: 120)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                selected = work.id
                            }
                        }

                        Text(work.day)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
//            DispatchQueue.main.async {
//                viewModel.requestAuthorization { success in
//                    if success {
//                        self.data = viewModel.requestExerciseTimeFromLastWeek()
//                    }
//                }
//
//                if data.count > 0 {
//                    print("czy ilosc treningow > 0")
//                    workoutData = [
//                        Daily(id: 0, day: "Pon", workout_In_Min: CGFloat(data[0].count)),
//                        Daily(id: 1, day: "Wt", workout_In_Min: CGFloat(data[1].count)),
//                        Daily(id: 2, day: "Sr", workout_In_Min: CGFloat(data[2].count)),
//                        Daily(id: 3, day: "Czw", workout_In_Min: CGFloat(data[3].count)),
//                        Daily(id: 4, day: "Pt", workout_In_Min: CGFloat(data[4].count)),
//                        Daily(id: 5, day: "Sob", workout_In_Min: CGFloat(data[5].count)),
//                        Daily(id: 6, day: "Nd", workout_In_Min: CGFloat(data[6].count)),
//                    ]
//                } else {
//                    print("nie jest > 0")
//                }
//            }
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .cornerRadius(10)
        .padding()
    }

    // Calculating the Hours and converting into a height
    // Max height = 200
    func getHeight(value: CGFloat) -> CGFloat {
        // Convert value into minutes
        // 24hrs = 1440 mins
        let hrs = CGFloat(value / 1440) * 200
        return hrs
    }

    // Calculating Hours
    func getHrs(value: CGFloat) -> String {
        let hrs = value / 60
        return String(format: "%.1f", hrs)
    }
}

struct RoundedShape: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5))

        return Path(path.cgPath)
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(selected: .constant(1)).preferredColorScheme(.dark)
    }
}
