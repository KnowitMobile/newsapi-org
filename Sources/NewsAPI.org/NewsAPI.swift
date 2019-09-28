import Foundation


final class NewsAPI {

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
    var apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    enum Scope: String {
        case topHeadlines = "/v2/top-headlines"
        case everything = "/v2/everything"
        case sources = "/v2/sources"
    }

    typealias ArticleRequestCompletion = (Result<[Article],Error>) -> Void
    typealias SourceRequestCompletion = (Result<[Source],Error>) -> Void

    private func buildRequest(scope: Scope) -> URLRequest {
        URLRequestBuilder(baseURL: baseURL, endpoint: scope)!
            .apiKey(apiKey)
            .country(iso3166: "se")
            .build()
    }

    func articles(scope: Scope, country code: String? = Locale.current.regionCode, completion: @escaping ArticleRequestCompletion) {

        let task = URLSession.shared.dataTask(with: buildRequest(scope: scope)) { (data, response, error) in
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

    @available(iOS 13, OSX 10.15, *)
    func articles(scope: Scope) -> URLSession.DataTaskPublisher {
        URLSession.shared.dataTaskPublisher(for: buildRequest(scope: scope))
    }
}
