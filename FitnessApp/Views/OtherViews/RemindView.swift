//
//  RemindView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 18/04/2023.
//

import SwiftUI

struct RemindView: View {
    var body: some View {
        VStack {
            Spacer()
            // DropdownView()
            Spacer()
            Button(action: {}) {
                Text("Utwórz")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.primary)
            }.padding(.bottom, 15)
            Button(action: {}) {
                Text("Pomiń")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.primary)
            }
        }.navigationTitle("Przypomnij")
            .padding(.bottom, 15)
    }
}

struct RemindView_Previews: PreviewProvider {
    static var previews: some View {
        RemindView()
    }
}
