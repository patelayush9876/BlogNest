struct Blog: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let tags: [String]
    let author: String
    let createdAt: String
}

struct BlogResponse: Codable {
    let blogs: [Blog]
    let totalPages: Int
    let currentPage: Int
}
