import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

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
                    // Handle login success (e.g., navigate to dashboard)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
