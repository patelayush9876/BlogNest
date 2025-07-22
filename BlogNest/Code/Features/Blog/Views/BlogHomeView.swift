
import SwiftUI

struct BlogHomeView: View {
    @StateObject private var viewModel = BlogHomeViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.blogs.isEmpty {
                    ProgressView("Loading Blogs...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.blogs) { blog in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(blog.title)
                                    .font(.headline)
                                Text(blog.content.prefix(100) + "...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Tags: \(blog.tags.joined(separator: ", "))")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 6)
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else if viewModel.blogs.count >= 10 {
                            Button("Load More") {
                                viewModel.fetchBlogs()
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("BlogNest")
            .onAppear {
                viewModel.fetchInitialBlogs()
            }
        }
    }
}
