//
//  ActivityCard.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 23/09/2023.
//

import SwiftUI

struct ActivityCard: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Daily steps")
                        .font(.system(size: 16))

                    Text("Goal: 10,000")
                        .font(.system(size: 12))
                }

                Spacer()

                Image(systemName: "figure.walk")
                    .foregroundColor(.green)
            }
            .padding()

            Text("10,000")
                .font(.system(size: 24))
        }
    }
}

struct ActivityCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCard()
    }
}
