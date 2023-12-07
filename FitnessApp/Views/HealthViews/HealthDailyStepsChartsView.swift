//
//  HealthDailyStepsChartsView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 24/09/2023.
//

import Charts
import SwiftUI

enum ChartOptions {
    case oneWeek
    case oneMonth
    case threeMonth
    case yearToDate
    case oneYear
}

struct HealthDailyStepsChartsView: View {
    @EnvironmentObject var manager: HealthDailyStepsViewModel
    @State var selectedChart: ChartOptions = .oneWeek
    @State var averageSteps: Double = 0
    @State var totalSteps: Double = 0

    let staticData = StaticData.staticData

    var body: some View {
        ScrollView {
            Spacer().frame(height: 40)
            VStack(spacing: 12) {
                HStack {
                    Spacer()

                    VStack {
                        Text("Średnia")
                            .font(.largeTitle)
                            .padding()

                        Text("\(Int(averageSteps)) kroków")
                    }

                    Spacer()

                    VStack {
                        Text("Razem")
                            .font(.largeTitle)
                            .padding()

                        Text("\(Int(totalSteps)) kroków")
                    }

                    Spacer()
                }
                .padding(.bottom)

                ZStack {
                    switch selectedChart {
                    case .oneWeek:
                        Chart {
                            ForEach(staticData.isTestData ? manager.oneWeekChartStaticData : manager.oneWeekChartData) { daily in
                                BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Kroki", daily.stepCount))
                            }
                        }
                        .onAppear {
                            if !staticData.isTestData && manager.oneWeekChartData.count > 0 {
                                totalSteps = manager.oneWeekChartData.reduce(0.00, { $0 + $1.stepCount })
                                averageSteps = totalSteps / Double(manager.oneWeekChartData.count)
                            } else if manager.oneWeekChartStaticData.count > 0 {
                                totalSteps = manager.oneWeekChartStaticData.reduce(0.00, { $0 + $1.stepCount })
                                averageSteps = totalSteps / Double(manager.oneWeekChartStaticData.count)
                            }
                        }
                    case .oneMonth:
                        Chart {
                            ForEach(staticData.isTestData ? manager.oneMonthChartStaticData : manager.oneMonthChartData) { daily in
                                BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Kroki", daily.stepCount))
                            }
                        }
                        .onAppear {
                            if !staticData.isTestData && manager.oneMonthChartData.count > 0 {
                                totalSteps = manager.oneMonthChartData.reduce(0.00, { $0 + $1.stepCount })
                                averageSteps = totalSteps / Double(manager.oneMonthChartData.count)
                            } else if manager.oneMonthChartStaticData.count > 0 {
                                totalSteps = manager.oneMonthChartStaticData.reduce(0.00, { $0 + $1.stepCount })
                                averageSteps = totalSteps / Double(manager.oneMonthChartStaticData.count)
                            }
                        }
                    case .threeMonth:
                        Chart {
                            ForEach(staticData.isTestData ? manager.threeMonthChartStaticData : manager.threeMonthChartData) { daily in
                                BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Kroki", daily.stepCount))
                            }
                        }
                        .onAppear {
                            if !staticData.isTestData && manager.threeMonthChartData.count > 0 {
                                totalSteps = manager.threeMonthChartData.reduce(0.00, { $0 + $1.stepCount })
                                averageSteps = totalSteps / Double(manager.threeMonthChartData.count)
                            } else if manager.threeMonthChartStaticData.count > 0 {
                                totalSteps = manager.threeMonthChartStaticData.reduce(0.00, { $0 + $1.stepCount })
                                averageSteps = totalSteps / Double(manager.threeMonthChartStaticData.count)
                            }
                        }
                    case .yearToDate:
                        Chart {
                            ForEach(staticData.isTestData ? manager.yearToDateChartStaticData : manager.yearToDateChartData) { daily in
                                LineMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Kroki", daily.stepCount))
                            }
                        }
                        .onAppear {
                            if !staticData.isTestData && manager.yearToDateChartData.count > 0 {
                                totalSteps = manager.yearToDateChartData.reduce(0.00, { $0 + $1.stepCount })
                                averageSteps = totalSteps / Double(manager.yearToDateChartData.count)
                            } else if manager.yearToDateChartStaticData.count > 0 {
                                totalSteps = manager.yearToDateChartStaticData.reduce(0.00, { $0 + $1.stepCount })
                                averageSteps = totalSteps / Double(manager.yearToDateChartStaticData.count)
                            }
                        }
                    case .oneYear:
                        Chart {
                            ForEach(staticData.isTestData ? manager.oneYearChartStaticData : manager.oneYearChartData) { daily in
                                LineMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Kroki", daily.stepCount))
                            }
                        }
                        .onAppear {
                            if !staticData.isTestData && manager.oneYearChartData.count > 0 {
                                totalSteps = manager.oneYearChartData.reduce(0.00, { $0 + $1.stepCount })
                                averageSteps = totalSteps / Double(manager.oneYearChartData.count)
                            } else if manager.oneYearChartStaticData.count > 0 {
                                totalSteps = manager.oneYearChartStaticData.reduce(0.00, { $0 + $1.stepCount })
                                averageSteps = totalSteps / Double(manager.oneYearChartStaticData.count)
                            }
                        }
                    }
                }
                .foregroundColor(.green)
                .frame(height: 350)
                .padding(.horizontal)

                HStack {
                    Button("1T") {
                        withAnimation {
                            selectedChart = .oneWeek
                        }
                    }
                    .padding(.all)
                    .foregroundColor(selectedChart == .oneWeek ? .white : .green)
                    .background(selectedChart == .oneWeek ? .green : .clear)
                    .cornerRadius(10)

                    Button("1M") {
                        withAnimation {
                            selectedChart = .oneMonth
                        }
                    }
                    .padding(.all)
                    .foregroundColor(selectedChart == .oneMonth ? .white : .green)
                    .background(selectedChart == .oneMonth ? .green : .clear)
                    .cornerRadius(10)

                    Button("3M") {
                        withAnimation {
                            selectedChart = .threeMonth
                        }
                    }
                    .padding(.all)
                    .foregroundColor(selectedChart == .threeMonth ? .white : .green)
                    .background(selectedChart == .threeMonth ? .green : .clear)
                    .cornerRadius(10)

                    Button("6M") {
                        withAnimation {
                            selectedChart = .yearToDate
                        }
                    }
                    .padding(.all)
                    .foregroundColor(selectedChart == .yearToDate ? .white : .green)
                    .background(selectedChart == .yearToDate ? .green : .clear)
                    .cornerRadius(10)

                    Button("1R") {
                        withAnimation {
                            selectedChart = .oneYear
                        }
                    }
                    .padding(.all)
                    .foregroundColor(selectedChart == .oneYear ? .white : .green)
                    .background(selectedChart == .oneYear ? .green : .clear)
                    .cornerRadius(10)
                }
            }
        }
        .onAppear {
            manager.fetchPastWeekStepData()
            manager.fetchPastThreeMonthsStepData()
            manager.fetchYearToDateStepData()
        }
    }
}

struct HealthDailyStepsChartsView_Previews: PreviewProvider {
    static var previews: some View {
        HealthDailyStepsChartsView()
            .environmentObject(HealthDailyStepsViewModel())
    }
}
