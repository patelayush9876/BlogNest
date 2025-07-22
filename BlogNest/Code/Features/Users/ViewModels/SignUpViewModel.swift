import Foundation

final class SignupViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func signup() {
        // Basic field validation
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        errorMessage = nil
        isLoading = true

        let request = RegisterRequest(name: name, email: email, password: password, role: "user")

        // Simulate API call here
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            print("User registered: \(request)")
            // Handle navigation or success message
        }
    }
}
