//
//  LoginSignUpView.swift
//  FitnessApp
//
//  Created by Adrian Rodzic on 06/05/2023.
//

import SwiftUI

struct LoginSignupView: View {
    @StateObject var viewModel: LoginSignupViewModel
    @Binding var isPushed: Bool

    init(
        mode: LoginSignupViewModel.Mode,
        isPushed: Binding<Bool>
    ) {
        _viewModel = .init(wrappedValue: .init(mode: mode))
        _isPushed = isPushed
    }

    var emailTextField: some View {
        TextField(viewModel.emailPlaceholderText, text: $viewModel.emailText)
            .modifier(TextFieldCustomRoundedStyle())
            .autocapitalization(.none)
    }

    var passwordTextField: some View {
        SecureField(viewModel.passwordPlaceholderText, text: $viewModel.passwordText)
            .modifier(TextFieldCustomRoundedStyle())
            .autocapitalization(.none)
    }

    var actionButton: some View {
        Button(viewModel.buttonTitle) {
            viewModel.tappedActionButton()
        }.padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color(.systemGreen))
            .cornerRadius(16)
            .padding()
            .disabled(!viewModel.isValid)
            .opacity(viewModel.isValid ? 1 : 0.4)
    }

    var accountButton: some View {
        NavigationLink(
            destination: viewModel.mode == .login
                ? LoginSignupView(mode: .signup, isPushed: .constant(false))
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: LoopBackView())
                : LoginSignupView(mode: .login, isPushed: .constant(false))
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: LoopBackView())
        ) {
            viewModel.mode == .login ? Text("Nie masz konta? Zarejestruj sie") : Text("Masz juz konto? Przejdz do logowania")
        }
    }

    var body: some View {
        VStack {
            Text(viewModel.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(viewModel.subtitle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color(.systemGray2))
            Spacer()
                .frame(height: 50)
            emailTextField
            passwordTextField
            actionButton
            if viewModel.mode != .link {
                accountButton
            }
        }
        .onReceive(viewModel.$isPushed, perform: { isPushed in
            self.isPushed = isPushed
        })
        .padding()
    }
}

struct LoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginSignupView(mode: .login, isPushed: .constant(false))
        }
    }
}

struct LoopBackView: View {
    var body: some View {
        NavigationLink(
            destination: LandingPage()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: EmptyView())
        ) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
        }
    }
}