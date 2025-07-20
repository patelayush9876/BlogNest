import Foundation

struct AuthRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
    let role: String 
}

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let user: UserModel
}

struct UserModel: Codable {
    let _id: String
    let name: String
    let email: String
    let role: String
}

struct BaseResponse<T: Codable>: Codable {
    let status: Bool
    let message: String
    let data: T
}

struct APIError: Codable, Error {
    let message: String
}
