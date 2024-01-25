//
//  HealthDashboardView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import Firebase
import SwiftUI

struct HealthDashboardView: View {
    @State var selected: Int = 0
    @State private var userEmail: String = ""
    @State private var userName: String = ""

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HStack {
                    AvatarIconView()
                    Text("Witaj \(userName)")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Spacer(minLength: 0)

                    NavigationLink(destination: HealthSettingsView()) {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .frame(width: 30, height: 25)
                            .foregroundColor(Color(.white))
                    }
                }
                .padding(.horizontal, 25)

                BarChartView(selected: $selected)

                HealthSummaryView()
            }
        }
        .onAppear {
            if let user = Auth.auth().currentUser {
                userEmail = user.email ?? "No Email"

                if let atIndex = userEmail.firstIndex(of: "@") {
                    userName = String(userEmail.prefix(upTo: atIndex))
                } else {
                    userName = "użytkowniku"
                }
            } else {
                userName = "użytkowniku"
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct HealthDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        HealthDashboardView()
    }
}
