//
//  ChallengeItemView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 07/05/2023.
//

import SwiftUI

struct ChallengeItemView: View {
    private let viewModel: ChallengeItemViewModel

    init(viewModel: ChallengeItemViewModel) {
        self.viewModel = viewModel
    }

    var titleRow: some View {
        HStack {
            Text(viewModel.title)
                .font(.system(size: 22, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
            Spacer()
            Image(systemName: "trash")
                .onTapGesture {
                    viewModel.send(action: .delete)
                }
        }
    }

    var dailyIncreaseRow: some View {
        HStack {
            Text(viewModel.dailyIncreaseText)
                .font(.system(size: 20, weight: .bold))
            Spacer()
        }
    }

    var todayView: some View {
        VStack(spacing: 25) {
            Text(viewModel.todayTitle)
                .font(.title3)
                .fontWeight(.medium)
            Text(viewModel.todayRepTitle)
                .font(.system(size: 18, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            Button(viewModel.isDayComplete || viewModel.isComplete ? "Ukończono" : "Zakończ") {
                viewModel.send(action: .toggleComplete)
            }
            .disabled(viewModel.isComplete)
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .font(Font.caption.weight(.semibold))
            .background(viewModel.isDayComplete ? Color.circleTrack : Color.primaryButton)
            .cornerRadius(8)
        }
        .frame(width: 120)
    }

    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: 15) {
                VStack {
                    titleRow
                    ProgressCircleView(viewModel: viewModel.progressCircleViewModel)
                        .frame(width: 90, height: 90)
                    dailyIncreaseRow
                }
                Divider()
                todayView
            }.padding(.vertical, 10)
            Spacer()
        }
        .background(
            Rectangle()
                .fill(Color.primaryButton)
                .cornerRadius(5)
        ).padding()
    }
}
