import Foundation

public class AuthService {
    static let shared = AuthService()
    public init() {}
    
    private let baseURL = "http://localhost:3000/api/v1/auth"

    // MARK: - Login
    func login(email: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/login")!
        let requestBody = AuthRequest(email: email, password: password)
        sendRequest(to: url, body: requestBody, completion: completion)
    }

    // MARK: - Register
    func register(name: String, email: String, password: String, role: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/register")!
        let requestBody = RegisterRequest(name: name, email: email, password: password, role: role)
        sendRequest(to: url, body: requestBody, completion: completion)
    }

    // MARK: - Refresh Token
    func refreshToken(_ refreshToken: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/refresh")!
        let body = ["refreshToken": refreshToken]
        sendRequest(to: url, body: body, completion: completion)
    }

    // MARK: - Logout
    func logout(refreshToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/logout")!
        let body = ["refreshToken": refreshToken]

        sendRequest(to: url, body: body) { (result: Result<BaseResponse<String>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Reusable POST Handler
    private func sendRequest<T: Codable, U: Codable>(to url: URL, body: T, completion: @escaping (Result<U, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                return completion(.failure(APIError(message: "No data received")))
            }

            do {
                let wrapper = try JSONDecoder().decode(BaseResponse<U>.self, from: data)
                completion(.success(wrapper.data))
            } catch {
                if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                    completion(.failure(apiError))
                } else {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
