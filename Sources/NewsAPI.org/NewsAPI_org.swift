import Foundation

let apiKey = "2a714d92477f41cb82e3e68c1bf4e0b7"

struct NewsAPIResponse: Decodable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

struct Article: Decodable {
    var source: Source
    var author: String?
    var title: String
    var description: String
    var url: String
    var urlToImage: String?
    var publishedAt: Date
    var content: String?
}

struct Source: Decodable {
    var id: String?
    var name: String
}


final class NewsAPI {

//    enum Error: Swift.Error {
//        case missingApiKey
//        case invalidApiKey
//        case serverError
//    }

    class URLRequestBuilder {
        private var url: URLComponents
        private var apiKey: String?

        init?(baseURL: URL, endpoint: Scope) {

            guard let validURL = URL(string: endpoint.rawValue, relativeTo: baseURL) else {
                return nil
            }
            self.url = URLComponents(url: validURL, resolvingAgainstBaseURL: false)!
            if url.queryItems == nil {
                url.queryItems = [URLQueryItem]()
            }
        }

        func apiKey(_ apiKey: String) -> Self {
            self.apiKey = apiKey
            return self
        }

        func country(iso3166 code: String) -> Self {
            if let index = url.queryItems!.firstIndex(where: { $0.value == code }) {
                url.queryItems![index] = URLQueryItem(name: "country", value: code)
            }
            return self
        }

        func category(_ category: String) -> Self {
            if let index = url.queryItems!.firstIndex(where: { $0.value == category }) {
                url.queryItems![index] = URLQueryItem(name: "category", value: category)
            }
            return self
        }

        func build() -> URLRequest {
            var request = URLRequest(url: self.url.url!)
            if let apiKey = apiKey {
                request.setValue(apiKey, forHTTPHeaderField: "Authorization")
            }
            return request
        }
    }

    let baseURL = URL(string: "https://newsapi.org/")!

    enum Scope: String {
        case topHeadlines = "/v2/top-headlines"
        case everything = "/v2/everything"
        case sources = "/v2/sources"
    }

    typealias ArticleRequestCompletion = (Result<[Article],Error>) -> Void
    typealias SourceRequestCompletion = (Result<[Source],Error>) -> Void

    func articles(scope: Scope, country code: String? = Locale.current.regionCode, completion: @escaping ArticleRequestCompletion) {
        let builder = URLRequestBuilder(baseURL: baseURL, endpoint: scope)!
        let request = builder.apiKey(apiKey)
            .country(iso3166: "se")
            .build()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return completion(.failure(error!))
            }
            do {
                let response = try JSONDecoder().decode(NewsAPIResponse.self, from: data!)
                return completion(.success(response.articles))
            } catch {
                return completion(.failure(error))
            }

        }
        task.resume()

    }

    func sources(completion: @escaping SourceRequestCompletion) {

    }

}
