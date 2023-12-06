//
//  AvatarIconView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import SwiftUI

struct AvatarIconView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Color.lightGreen.ignoresSafeArea()

            Circle().stroke(.white, lineWidth: 3)
                .blendMode(.overlay)

            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 35, height: 35, alignment: .center)
                .cornerRadius(60)
                .foregroundStyle(.white, .black)

        }.cornerRadius(50).frame(width: 42, height: 42, alignment: .center)
    }
}

struct AvatarIconView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarIconView().preferredColorScheme(.dark)
    }
}
