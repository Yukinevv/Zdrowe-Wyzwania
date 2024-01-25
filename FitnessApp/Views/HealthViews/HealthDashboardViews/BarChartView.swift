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

    var viewModel: HealthExerciseTimeViewModel = HealthExerciseTimeViewModel()

    @State var workoutData: [Daily] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text("Codzienne treningi (godz)")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .foregroundColor(.white)

            HStack(spacing: 15) {
                ForEach(StaticData.staticData.isTestData ? StaticData.staticData.workoutStaticData : workoutData) { work in
                    VStack {
                        VStack {
                            Spacer(minLength: 0)

                            if selected == work.id {
                                Text(getHrs(value: work.workout_In_Min))
                                    .foregroundColor(Color("Color"))
                                    .padding(.bottom)
                            }
                            // gradient bars
                            RoundedShape()
                                .fill(LinearGradient(gradient: .init(colors: selected == work.id ? colors : backgrnd), startPoint: .top, endPoint: .bottom))
                                .frame(height: (getHeight(value: work.workout_In_Min) * 8) > 80 ? 80 : getHeight(value: work.workout_In_Min) * 8)
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
            if !StaticData.staticData.isTestData && workoutData.isEmpty {
                viewModel.requestAuthorization { success in
                    if success {
                        viewModel.requestExerciseTimeFromLastWeek { data in
                            print("data ilosc: \(data.count)")
                            if data.count > 0 {
                                print("czy ilosc treningow > 0")
                                for i in 0 ..< data.count {
                                    workoutData.append(Daily(id: i, day: data[i].date.weekday(), workout_In_Min: CGFloat(data[i].count)))
                                }
                            } else {
                                print("nie jest > 0")
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .cornerRadius(10)
        .padding()
    }

    // wyliczenie godzin i konwersja wzgledem wysokosci
    // max height = 200
    func getHeight(value: CGFloat) -> CGFloat {
        // 24h = 1440 min
        let hrs = CGFloat(value / 1440) * 200
        return hrs
    }

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
