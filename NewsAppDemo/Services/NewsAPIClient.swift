//
//  NewsAPIClient.swift
//  NewsAppDemo
//
//  Created by Flannery Jefferson on 2020-11-06.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation

class NewsAPIClient {
    
    init() {}
    
    private let apiKey = "b94ed102b02949968a60d2e32847d05d" // Don't put your API key in your code for a real app!
    private let allArticlesEndpoint = "https://newsapi.org/v2/everything"
    private let topHeadlinesEndpoint = "https://newsapi.org/v2/top-headlines"
    
    private let decoder = JSONDecoder()
    private let urlSession = URLSession(configuration: .default)
    
    public func fetchArticles(query: String?, completion: @escaping ([NewsArticle]?, NewsAPIClientError?) -> Void) {
        var urlString: String

        let languageQuery = "language=en"
        if let q = query, !q.isEmpty,
            let escapedQuery = q.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            urlString = "\(allArticlesEndpoint)?q=\(escapedQuery)&\(languageQuery)"
        } else {
            urlString = "\(topHeadlinesEndpoint)?\(languageQuery)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil, .invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let dataTask = urlSession.dataTask(with: request, completionHandler: { data, response, error in
            if let e = error {
                completion(nil, .other(e))
                return
            }
            guard let d = data else {
                completion(nil, .noData)
                return
            }
            /* --- DEBUGGING */
//            do {
//                // Check the format of the data in JSON
//                if let json = try JSONSerialization.jsonObject(with: d, options: []) as? [String: Any] {
//                    print(json)
//                }
//            } catch let error as NSError {
//                print("Failed to load: \(error.localizedDescription)")
//            }
            /* -------- */
            
            do {
                let apiResponse = try self.decoder.decode(NewsAPIResponse.self, from: d)
                guard apiResponse.status == .ok else {
                    completion(nil, .badStatusCode(apiResponse.code))
                    return
                }
                completion(apiResponse.articles, nil)
            } catch {
                completion(nil, .badData)
                return
            }
        })
        
        dataTask.resume()
    }
}

class NewsAPIResponse: Decodable {
    var articles: [NewsArticle]?
    var totalResults: Int?
    var status: NewsAPIResponseStatus
    var message: String?
    var code: NewsAPIErrorCode?
}

class NewsArticle: Decodable {
    var source: NewsArticleSource?
    var title: String?
    var author: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}


class NewsArticleSource: Decodable {
    var id: String?
    var name: String?
}


enum NewsAPIResponseStatus: String, Decodable {
    case ok
    case error
}

// Errors defined by the third-party API (https://newsapi.org/docs/errors):
enum NewsAPIErrorCode: String, Decodable {
    case apiKeyDisabled
    case apiKeyExhausted
    case apiKeyInvalid
    case apiKeyMissing
    case parameterInvalid
    case parametersMissing
    case rateLimited
    case sourcesTooMany
    case sourceDoesNotExist
    case unexpectedError
    
    
    var userMessage: String {
        switch self {
            
        case .apiKeyDisabled:
            return "Your API key has been disabled"
        case .apiKeyExhausted:
            return "Your API key is at is usage limit"
        case .apiKeyInvalid:
            return "Invalid API key"
        case .apiKeyMissing:
            return "API key is missing"
        case .parameterInvalid:
            return "Invalid parameter provided"
        case .parametersMissing:
            return "Missing parameters"
        case .rateLimited:
            return "Rate limited"
        case .sourcesTooMany:
            return "Too many sources"
        case .sourceDoesNotExist:
            return "Source does not exist"
        case .unexpectedError:
            return "Unexpected error"
        }
    }
}

// Errors that our NewsAPIClient class can throw
enum NewsAPIClientError {
    case invalidURL
    case noData
    case other(Error)
    case badData
    case badStatusCode(NewsAPIErrorCode?)
    
    
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "The request URL is invalid"
        case .noData:
            return "No data was returned"
        case .other(let error):
            return error.localizedDescription
        case .badData:
            return "The API return unexpected data"
        case .badStatusCode(let code):
            if let code = code {
                return code.userMessage
            }
            return "The API encountered an error"
        }
    }
}
