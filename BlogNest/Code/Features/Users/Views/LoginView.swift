import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        ZStack {
            // Background Image
            Image("LoginBG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Logo
                Image("logo")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle()) // Optional: Make it circular

                // Login Title
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white) // for better contrast

                // Email Field
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .padding()
                    .background(.ultraThinMaterial) // Translucent blur
                    .cornerRadius(10)
                    .overlay( // Optional border
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(34.259), lineWidth: 1)
                    )


                // Password Field
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(34.259), lineWidth: 1)
                    )

                // Loading Indicator or Login Button
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button("Login") {
                        viewModel.login()
                    }
                    .buttonStyle(.borderedProminent)
                }

                // Error Message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.top)
                }
            }
            .padding(.horizontal, 100) // Apply horizontal padding to the whole VStack
                    .padding(.top, 5)
        }
    }
}
