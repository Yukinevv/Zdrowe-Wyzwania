//
//  WaterCardView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 01/10/2023.
//

import SwiftUI

struct WaterCardView: View {
    var value: Double

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .strokeBorder(.white, lineWidth: 1)
                .blendMode(.overlay)
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color(#colorLiteral(red: 0.1463547051, green: 0.1574619114, blue: 0.2792110443, alpha: 1)))
                    .blendMode(.overlay)
                )
                // .frame(width: 165, height: 210).cornerRadius(30)
                .frame(width: 365, height: 410).cornerRadius(30)

            VStack(alignment: .center) {
                HStack {
                    Text("Woda")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Image(systemName: "humidity.fill")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(#colorLiteral(red: 0.3949169517, green: 0.6750054955, blue: 0.9382415414, alpha: 1)))
                }

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color(#colorLiteral(red: 0.4195603728, green: 0.6958546042, blue: 0.957184732, alpha: 1)))
                        .background(
                            ZStack(alignment: .top) {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(
                                        LinearGradient(colors: [Color(#colorLiteral(red: 0.03251739964, green: 0.2137796581, blue: 0.5376530886, alpha: 1)), Color(#colorLiteral(red: 0.4195603728, green: 0.6958546042, blue: 0.957184732, alpha: 1))], startPoint: .bottom, endPoint: .leading)
                                    )
                                    // .frame(width: 50, height: 130)
                                    .frame(width: 150, height: 230)

                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        .white.opacity(0.7)
                                    )
                                    // .frame(width: 50, height: 60)
                                    .frame(width: 150, height: 60)
                            }
                        )
                        // .frame(width: 50, height: 130).cornerRadius(30)
                        .frame(width: 150, height: 230).cornerRadius(40)

                    VStack {
                        Text("\(Int(value * 1000))")
                            .font(.system(size: 42)).fontWeight(.bold)
                            .shadow(color: .black.opacity(0.8), radius: 1, x: 1, y: 1)
                        Text("ml")
                            .font(.system(size: 32)).fontWeight(.semibold)
                            .shadow(color: .black.opacity(0.8), radius: 1, x: 1, y: 1)
                    }
                }

                Spacer()
            }
            .padding()
        }
        // .frame(width: 165, height: 210).cornerRadius(30)
        .frame(width: 365, height: 410).cornerRadius(30)
    }
}

struct WaterCardView_Previews: PreviewProvider {
    static var previews: some View {
        WaterCardView(value: 2)
    }
}
