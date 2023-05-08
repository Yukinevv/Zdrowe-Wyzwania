//
//  ContentView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 10/04/2023.
//

import SwiftUI

struct LandingPage: View {
    @StateObject private var viewModel = LandingViewModel()

    var title: some View {
        Text(viewModel.title)
            .font(.system(size: 64, weight: .bold))
            .foregroundColor(.black)
    }

    var loginButton: some View {
        HStack(spacing: 15) {
            Spacer()
            Image(systemName: viewModel.loginButtonImageName)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
            Text(viewModel.loginButtonTitle)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
            Spacer()
        }
    }

    var signupButton: some View {
        HStack(spacing: 15) {
            Spacer()
            Image(systemName: viewModel.signupButtonImageName)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
            Text(viewModel.signupButtonTitle)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
            Spacer()
        }
    }

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    Spacer().frame(height: proxy.size.height * 0.25)
                    title
                        .multilineTextAlignment(.center)
                    Spacer()
                        .frame(height: 50)
                    HStack(spacing: 30) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 50))
                        Image(systemName: "flag.circle.fill")
                            .font(.system(size: 50))
                    }
                    Spacer()
                    NavigationLink(
                        destination: LoginSignupView(
                            mode: .login,
                            isPushed: $viewModel.loginSignupPushed
                        )
                    ) {
                        loginButton
                    }.padding(15)
                        .buttonStyle(PrimaryButtonStyle())
                    NavigationLink(
                        destination: LoginSignupView(
                            mode: .signup,
                            isPushed: $viewModel.loginSignupPushed
                        )
                    ) {
                        signupButton
                    }.padding([.leading, .trailing, .bottom], 15)
                        .buttonStyle(PrimaryButtonStyle())
                    Button(action: {
                        viewModel.signInAnonymously()
                    }) {
                        Text(viewModel.alreadyButtonTitle)
                            .font(.system(size: 20, weight: .medium))
                    }.foregroundColor(.black)
                }
                .padding(.bottom, 150)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
                .background(
                    Image(viewModel.backgroundImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .overlay(Color.black.opacity(0.1))
                )
                .frame(width: proxy.size.width)
                .edgesIgnoringSafeArea(.all)
            }
        }.accentColor(.primary)
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
