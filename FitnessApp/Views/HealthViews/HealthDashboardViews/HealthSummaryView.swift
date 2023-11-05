//
//  HealthSummaryView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 14/10/2023.
//

import SwiftUI

struct HealthSummaryView: View {
    var body: some View {
        HStack {
            Text("Podsumowanie dnia")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(.white))

            Spacer(minLength: 0)
        }
        .padding()

        HealthCardsView()
    }
}

struct HealthSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        HealthSummaryView().preferredColorScheme(.dark)
    }
}
