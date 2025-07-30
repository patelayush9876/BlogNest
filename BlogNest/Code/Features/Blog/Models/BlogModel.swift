import Foundation

// MARK: - Blog Model
// This represents a single blog post
struct Blog: Codable, Identifiable {
    // Map "_id" from JSON to "id" in Swift for Identifiable protocol conformance
    let id: String // Corresponds to "_id" in JSON
    let title: String
    let content: String
    let author: Author // Nested Author struct
    let tags: [String]
    let published: Bool
    let createdAt: String // Or use Date if you implement a custom DateDecodingStrategy
    let updatedAt: String // Or use Date
    let v: Int // Corresponds to "__v" in JSON

    // Custom CodingKeys to map JSON keys with different Swift property names
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v" // Map __v to v
        case title, content, author, tags, published, createdAt, updatedAt
    }
}

// MARK: - Author Model
// This represents the author object nested within a blog
struct Author: Codable, Identifiable {
    let id: String // Corresponds to "_id" in JSON
    let name: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, email
    }
}

// MARK: - BlogResponse (Top-level response from API)
// This represents the overall structure of the API response
struct BlogResponse: Codable {
    let status: Bool
    let message: String
    let data: BlogResponseData // <--- This is the crucial change: 'data' is a nested object
}

// MARK: - BlogResponseData (Nested data object)
// This represents the content within the 'data' key of the API response
struct BlogResponseData: Codable {
    let blogs: [Blog] // Array of Blog objects
    let total: Int
    let page: Int
    let limit: Int
}
