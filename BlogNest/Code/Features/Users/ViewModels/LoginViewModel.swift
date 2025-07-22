import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isLoggedIn = false

    private let authService = AuthService()

    func login() {
        errorMessage = nil
        isLoading = true

        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let response):
                    print("Login success: \(response)")
                    
                    // Optionally store the token or user data here
                    // Example: UserDefaults.standard.set(response.token, forKey: "authToken")

                    self?.isLoggedIn = true // <- Trigger navigation
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
