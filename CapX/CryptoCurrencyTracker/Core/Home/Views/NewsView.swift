//
//  NewsView.swift
//  CapX
//
//  Created by Sameer Nikhil on 13/10/24.
//

import Foundation
import SwiftUI

struct NewsModel: Identifiable, Decodable {
    let id = UUID()
    let uuid: String
    let title: String
    let description: String
    let url: String
    let imageUrl: String
    let publishedAt: String
    let source: String
    
    enum CodingKeys: String, CodingKey {
        case uuid, title, description, url
        case imageUrl = "image_url"
        case publishedAt = "published_at"
        case source
    }
}


import Foundation
import Combine

class NewsViewModel: ObservableObject {
    @Published var newsArticles: [NewsModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    let apiToken = "xyLx4fLrqEI19N4StLHBQRs0deMH6WJsCLrlfS8s"
    
    func fetchNews() {
        guard let url = URL(string: "https://api.marketaux.com/v1/news/all?countries=in&filter_entities=true&limit=10&published_after=2024-10-12T16:11&api_token=\(apiToken)") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching news: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.newsArticles = response.data
            })
            .store(in: &cancellables)
    }
}

struct NewsResponse: Decodable {
    let data: [NewsModel]
}


import SwiftUI

struct NewsListView: View {
    @StateObject private var vm = NewsViewModel()
    
    var body: some View {
        NavigationView {
            List(vm.newsArticles) { article in
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: article.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 150)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                    Text(article.title)
                        .font(.headline)
                        .padding(.top, 5)
                    Text(article.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)
                    HStack {
                        Text(article.source)
                            .font(.footnote)
                            .foregroundColor(.blue)
                        Spacer()
                        Text(article.publishedAt)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical)
                .onTapGesture {
                    if let url = URL(string: article.url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
            .navigationTitle("Latest News")
            .onAppear {
                vm.fetchNews()
            }
        }
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView()
    }
}

import Foundation

struct StockNewsArticle: Identifiable, Codable {
    let id = UUID()
    let uuid: String
    let title: String
    let description: String
    let snippet: String
    let url: String
    let imageUrl: String
    let publishedAt: String
    let source: String

    enum CodingKeys: String, CodingKey {
        case uuid, title, description, snippet, url, imageUrl = "image_url", publishedAt = "published_at", source
    }
}

struct StockNewsResponse: Codable {
    let data: [StockNewsArticle]
}

import Foundation

class StockNewsViewModel: ObservableObject {
    @Published var articles: [StockNewsArticle] = []
    
    private let apiKey = "xyLx4fLrqEI19N4StLHBQRs0deMH6WJsCLrlfS8s"
    
    func fetchStockNews() {
        let urlString = "https://api.marketaux.com/v1/news/all?countries=in&filter_entities=true&limit=10&published_after=2024-10-12T16:11&api_token=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(StockNewsResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.articles = result.data
                    }
                } catch let error {
                    print("Error decoding: \(error)")
                }
            }
        }.resume()
    }
}


import SwiftUI

struct StockNewsView: View {
    @StateObject private var stockNewsVM = StockNewsViewModel()
    
    var body: some View {
        NavigationView {
            List(stockNewsVM.articles) { article in
                VStack(alignment: .leading, spacing: 10) {
                    Text(article.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(article.snippet)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                    
                    HStack {
                        Spacer()
                        Link("Read More", destination: URL(string: article.url)!)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 10)
            }
            .navigationTitle("Stock News")
            .onAppear {
                stockNewsVM.fetchStockNews()
            }
        }
    }
}

struct StockNewsView_Previews: PreviewProvider {
    static var previews: some View {
        StockNewsView()
    }
}
