import Foundation

class BlogService {
    static let shared = BlogService()
    // Changed baseURL to the common prefix: /api/v1
    private let baseURL = "http://localhost:3000/api/v1" // <--- CHANGE HERE

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
        // Construct the full path as "/blogs/blog" relative to the baseURL
        guard var components = URLComponents(string: "\(baseURL)/blogs/blogs") else { // <--- CHANGE HERE
            completion(.failure(URLError(.badURL)))
            return
        }
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "search", value: search)
        ]

        guard let url = components.url else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let request = createRequest(url: url, method: "GET")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching all blogs: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            print("Status Code for fetchAllBlogs: \(httpResponse.statusCode)")

            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(BlogResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    print("Decoding error for fetchAllBlogs: \(error.localizedDescription)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw data for fetchAllBlogs: \(jsonString)")
                    }
                    completion(.failure(error))
                }
            } else {
                completion(.failure(URLError(.cannotParseResponse)))
            }
        }.resume()
    }

    // You will also need to update the URLs for other functions if they follow a similar pattern.
    // For example:

    func fetchBlogById(id: String, completion: @escaping (Result<Blog, Error>) -> Void) {
        // Assuming single blog by ID is /api/v1/blog/:id or /api/v1/blogs/:id
        // Based on your get all path /api/v1/blogs/blog, a single blog might be /api/v1/blogs/:id or /api/v1/blog/:id
        // Let's assume the common REST pattern /api/v1/blogs/:id for now. Adjust if your API is different.
        guard let url = URL(string: "\(baseURL)/blogs/\(id)") else { // <--- Potentially CHANGE HERE depending on your actual API structure for single blog
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = createRequest(url: url, method: "GET")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching blog by ID: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            print("Status Code for fetchBlogById: \(httpResponse.statusCode)")

            if let data = data {
                do {
                    let blog = try JSONDecoder().decode(Blog.self, from: data)
                    completion(.success(blog))
                } catch {
                    print("Decoding error for fetchBlogById: \(error.localizedDescription)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw data for fetchBlogById: \(jsonString)")
                    }
                    completion(.failure(error))
                }
            } else {
                completion(.failure(URLError(.cannotParseResponse)))
            }
        }.resume()
    }

    func createBlog(title: String, content: String, tags: [String], token: String, completion: @escaping (Result<Blog, Error>) -> Void) {
        // Assuming create blog is /api/v1/blogs/blog or /api/v1/blogs
        // Sticking to /api/v1/blogs/blog as it's consistent with your fetch all.
        guard let url = URL(string: "\(baseURL)/blogs/blog") else { // <--- Potentially CHANGE HERE
            completion(.failure(URLError(.badURL)))
            return
        }

        let blogPayload = ["title": title, "content": content, "tags": tags] as [String : Any]
        guard let body = try? JSONSerialization.data(withJSONObject: blogPayload) else {
            completion(.failure(URLError(.cannotCreateFile)))
            return
        }

        let request = createRequest(url: url, method: "POST", body: body, token: token)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error creating blog: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            print("Status Code for createBlog: \(httpResponse.statusCode)")

            if let data = data {
                do {
                    let blog = try JSONDecoder().decode(Blog.self, from: data)
                    completion(.success(blog))
                } catch {
                    print("Decoding error for createBlog: \(error.localizedDescription)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw data for createBlog: \(jsonString)")
                    }
                    completion(.failure(error))
                }
            } else {
                completion(.failure(URLError(.cannotParseResponse)))
            }
        }.resume()
    }

    func updateBlog(id: String, updateData: [String: Any], token: String, completion: @escaping (Result<Blog, Error>) -> Void) {
        // Assuming update blog is /api/v1/blogs/:id or /api/v1/blog/:id
        // Sticking to /api/v1/blogs/:id for consistency with fetchBlogById
        guard let url = URL(string: "\(baseURL)/blogs/\(id)") else { // <--- Potentially CHANGE HERE
            completion(.failure(URLError(.badURL)))
            return
        }

        guard let body = try? JSONSerialization.data(withJSONObject: updateData) else {
            completion(.failure(URLError(.cannotCreateFile)))
            return
        }
        let request = createRequest(url: url, method: "PUT", body: body, token: token)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating blog: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            print("Status Code for updateBlog: \(httpResponse.statusCode)")

            if let data = data {
                do {
                    let blog = try JSONDecoder().decode(Blog.self, from: data)
                    completion(.success(blog))
                } catch {
                    print("Decoding error for updateBlog: \(error.localizedDescription)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw data for updateBlog: \(jsonString)")
                    }
                    completion(.failure(error))
                }
            } else {
                completion(.failure(URLError(.cannotParseResponse)))
            }
        }.resume()
    }

    func deleteBlog(id: String, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Assuming delete blog is /api/v1/blogs/:id or /api/v1/blog/:id
        // Sticking to /api/v1/blogs/:id for consistency with fetchBlogById
        guard let url = URL(string: "\(baseURL)/blogs/\(id)") else { // <--- Potentially CHANGE HERE
            completion(.failure(URLError(.badURL)))
            return
        }

        let request = createRequest(url: url, method: "DELETE", token: token)

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error deleting blog: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            print("Status Code for deleteBlog: \(httpResponse.statusCode)")

            if (200...204).contains(httpResponse.statusCode) {
                completion(.success(()))
            } else {
                let statusError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server returned status code \(httpResponse.statusCode)"])
                completion(.failure(statusError))
            }
        }.resume()
    }

    func fetchMyBlogs(token: String, completion: @escaping (Result<BlogResponse, Error>) -> Void) {
        // Assuming fetch my blogs is /api/v1/blogs/my or /api/v1/blog/my
        // Let's assume /api/v1/blogs/my for now.
        guard let url = URL(string: "\(baseURL)/blogs/my") else { // <--- Potentially CHANGE HERE
            completion(.failure(URLError(.badURL)))
            return
        }

        let request = createRequest(url: url, method: "GET", token: token)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching my blogs: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            print("Status Code for fetchMyBlogs: \(httpResponse.statusCode)")

            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(BlogResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    print("Decoding error for fetchMyBlogs: \(error.localizedDescription)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Raw data for fetchMyBlogs: \(jsonString)")
                    }
                    completion(.failure(error))
                }
            } else {
                completion(.failure(URLError(.cannotParseResponse)))
            }
        }.resume()
    }
}
