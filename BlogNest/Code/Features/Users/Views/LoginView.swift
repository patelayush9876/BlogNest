import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Image("LoginBG")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .clipShape(Circle())
                        .shadow(radius: 10)

                    Text("Login")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Group {
                        TextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)

                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Button(action: viewModel.login) {
                            Text("Log In")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.75))
                                .foregroundColor(.black)
                                .cornerRadius(12)
                        }
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 8)
                            .multilineTextAlignment(.center)
                    }

                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.footnote)

                        NavigationLink(destination: SignupView()) {
                            Text("Sign Up")
                                .foregroundColor(.white)
                                .font(.footnote.weight(.semibold))
                        }
                    }
                }
                .padding(.horizontal, 120)
            }
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                BlogHomeView()
            }
        }
    }
}
