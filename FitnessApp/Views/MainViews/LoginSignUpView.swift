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
    @State private var isChecked: Bool = false

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

    var checkbox: some View {
        HStack {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .onTapGesture {
                    isChecked.toggle()
                    viewModel.isSave.toggle()
                }
            Text("Zapamiętaj")
            Spacer()
        }
        .font(.system(size: 16))
        .padding()
        .onTapGesture {
            isChecked.toggle()
        }
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
            if viewModel.mode == .login {
                HStack {
                    Text("Nie masz konta? ")
                    Text("Zarejestruj się")
                        .foregroundStyle(.blue)
                }
            } else {
                HStack {
                    Text("Masz juz konto? ")
                    Text("Przejdź do logowania")
                        .foregroundStyle(.blue)
                }
            }
        }
    }

    var body: some View {
        VStack {
            Text(viewModel.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(viewModel.subtitle)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color(.systemGray2))
            Spacer()
                .frame(height: 50)
            emailTextField
            passwordTextField
            if viewModel.mode == .login {
                checkbox
            }
            actionButton
            if viewModel.mode != .link {
                accountButton
            }
        }
        .onReceive(viewModel.$isPushed, perform: { isPushed in
            self.isPushed = isPushed
        })
        .alert(isPresented: $viewModel.isValidFailed) {
            Alert(title: Text("Błąd"), message: Text("Niepoprawne dane logowania"), dismissButton: .default(Text("Ok")))
        }
        .padding()
        .preferredColorScheme(StaticData.staticData.isDarkMode ? .dark : .light)
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
            destination: LandingView()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: EmptyView())
        ) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Powrót")
            }
        }
    }
}
