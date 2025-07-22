import Foundation

class BlogService {
    static let shared = BlogService()
    private let baseURL = "https://localhost:3000/api/v1/blog"

    private func createRequest(url: URL, method: String, body: Data? = nil, token: String? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }

    func fetchAllBlogs(page: Int = 1, limit: Int = 10, search: String = "", completion: @escaping (Result<BlogResponse, Error>) -> Void) {
        guard var components = URLComponents(string: "\(baseURL)/blogs") else { return }
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "search", value: search)
        ]

        guard let url = components.url else { return }

        let request = createRequest(url: url, method: "GET")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(BlogResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func fetchBlogById(id: String, completion: @escaping (Result<Blog, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/blog/\(id)") else { return }
        let request = createRequest(url: url, method: "GET")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let blog = try JSONDecoder().decode(Blog.self, from: data)
                    completion(.success(blog))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func createBlog(title: String, content: String, tags: [String], token: String, completion: @escaping (Result<Blog, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/blog") else { return }

        let blogPayload = ["title": title, "content": content, "tags": tags] as [String : Any]
        let body = try? JSONSerialization.data(withJSONObject: blogPayload)

        let request = createRequest(url: url, method: "POST", body: body, token: token)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let blog = try JSONDecoder().decode(Blog.self, from: data)
                    completion(.success(blog))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func updateBlog(id: String, updateData: [String: Any], token: String, completion: @escaping (Result<Blog, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/blog/\(id)") else { return }

        let body = try? JSONSerialization.data(withJSONObject: updateData)
        let request = createRequest(url: url, method: "PUT", body: body, token: token)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let blog = try JSONDecoder().decode(Blog.self, from: data)
                    completion(.success(blog))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func deleteBlog(id: String, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/blog/\(id)") else { return }

        let request = createRequest(url: url, method: "DELETE", token: token)

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            completion(.success(()))
        }.resume()
    }

    func fetchMyBlogs(token: String, completion: @escaping (Result<BlogResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/my") else { return }

        let request = createRequest(url: url, method: "GET", token: token)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(BlogResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
