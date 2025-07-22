import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel = SignupViewModel()

    var body: some View {
        ZStack {
            // Background Image
            Image("LoginBG")
                .resizable()
                .scaledToFill()

            Color.black.opacity(0.4) // Dark overlay for contrast
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // App Logo or Icon
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .shadow(radius: 10)

                // Title
                Text("Create Account")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)

                // Input Fields
                Group {
                    TextField("Full Name", text: $viewModel.name)
                        .autocapitalization(.words)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )

                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )

                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }

                // Sign Up Button or Loading
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Button(action: viewModel.signup) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.85))
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .semibold))
                            .cornerRadius(12)
                    }
                }

                // Error Message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 8)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Optional: Login Prompt
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.footnote)
                    Button("Log In") {
                        // Navigate to login view
                    }
                    .foregroundColor(.white)
                    .font(.footnote.weight(.semibold))
                }
                .padding(.top, 1)
            }
            .padding(.horizontal, 150)
        }
    }
}
