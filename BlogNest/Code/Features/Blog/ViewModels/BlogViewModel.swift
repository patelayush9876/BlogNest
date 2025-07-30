import Foundation

class BlogHomeViewModel: ObservableObject {
    @Published var blogs: [Blog] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var currentPage = 1
    private var canLoadMore = true
    private let limit = 10
    
    func fetchInitialBlogs() {
        currentPage = 1
        canLoadMore = true
        blogs = []
        fetchBlogs()
    }

    func fetchBlogs(search: String = "") {
        guard canLoadMore else { return }
        isLoading = true
        errorMessage = nil

        BlogService.shared.fetchAllBlogs(page: currentPage, limit: limit, search: search) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let response):
                    // --- THE FIX IS HERE ---
                    // Access blogs through the 'data' property of the response
                    if self?.currentPage == 1 {
                        self?.blogs = response.data.blogs // Corrected: response.data.blogs
                    } else {
                        self?.blogs.append(contentsOf: response.data.blogs) // Corrected: response.data.blogs
                    }
                    // Also update total and limit based on the nested data
                    self?.currentPage += 1
                    self?.canLoadMore = response.data.blogs.count == self?.limit // Corrected: response.data.blogs.count
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
