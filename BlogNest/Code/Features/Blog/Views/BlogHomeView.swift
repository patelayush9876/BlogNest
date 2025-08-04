import SwiftUI

struct BlogHomeView: View {
    @StateObject private var viewModel = BlogHomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg2")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()

                ScrollView {
                    VStack(spacing: 16) {
                        if viewModel.isLoading && viewModel.blogs.isEmpty {
                            ProgressView("Loading Blogs...")
                                .padding()
                        } else if let error = viewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            ForEach(viewModel.blogs) { blog in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(blog.title)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)

                                    Text(blog.content)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .lineLimit(3)

                                    Text("Tags: \(blog.tags.joined(separator: ", "))")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                        .lineLimit(1)

                                    HStack(spacing: 24) {
                                        Button(action: {}) {
                                            Image(systemName: "heart")
                                        }

                                        Button(action: {}) {
                                            Image(systemName: "bubble.right")
                                        }

                                        Button(action: {}) {
                                            Image(systemName: "paperplane")
                                        }
                                    }
                                    .font(.system(size: 18))
                                    .padding(.top, 4)
                                }
                                .padding()
                                .frame(height: 180)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemBackground).opacity(0.85)) // Slight opacity for readability
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                .padding(.horizontal, 20)
                            }

                            if viewModel.isLoading {
                                ProgressView().padding()
                            } else if viewModel.blogs.count >= 10 {
                                Button("Load More") {
                                    viewModel.fetchBlogs()
                                }
                                .padding()
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("BlogNest")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.fetchInitialBlogs()
            }
        }
    }
}
