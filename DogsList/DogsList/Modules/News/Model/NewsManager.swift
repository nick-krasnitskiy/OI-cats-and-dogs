//
//  NewsManager.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 20.08.2021.
//

import Foundation

protocol NewsManagerDelegate: AnyObject {
    func didUpdateNews(_ newsManager: NewsManager, news: News)
    func didFailWithError(error: Error)
    func startActivityIndicator()
    func stopActivityIndicator()
    func didFailWithResponce(response: HTTPURLResponse)
    func notResponce()
}

private let apiNewsKey = "97ac8d9db2c64e82995a456fca6f29f6"

enum NewsEndpoint {
    case searchEndPoint(keyWord: String)
    case topNewsEndPoint(counry: String)
    
    var url: URL {
        switch self {
        case .searchEndPoint(let keyWord):
            return .makeEndpointForSearch(parameter: keyWord, apikey: apiNewsKey)
        case .topNewsEndPoint(let country):
            return .makeEndpointForTopNews(country: country, apikey: apiNewsKey)
        }
    }
}

struct NewsManager {
    
    weak var delegate: NewsManagerDelegate?
    
    func fetchTopNews() {
        let endpointOne = NewsEndpoint.topNewsEndPoint(counry: "us").url
        performRequestForTopNews(with: endpointOne)
    }
    
    func performRequestForTopNews(with url: URL) {
        
        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
                return
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        if let safeData = data {
                            if let topNews = self.parseJSONForTopNews(safeData) {
                                self.delegate?.didUpdateNews(self, news: topNews)
                                self.delegate?.stopActivityIndicator()
                            }
                        }
                    case nil:
                        self.delegate?.notResponce()
                        self.delegate?.stopActivityIndicator()
                    default:
                        self.delegate?.didFailWithResponce(response: httpResponse)
                        self.delegate?.stopActivityIndicator()
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func parseJSONForTopNews(_ newsData: Data) -> News? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(News.self, from: newsData)
            
            let topNews = News(status: decodedData.status, totalResults: decodedData.totalResults, articles: decodedData.articles)
            return topNews
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

private extension URL {
    static func makeEndpointForSearch(parameter: String, apikey: String) -> URL {
        URL(string: "https://newsapi.org/v2/everything?q=\(parameter)&apiKey=\(apikey)&sortBy=relevancy")!
    }
    
    static func makeEndpointForTopNews(country: String, apikey: String) -> URL {
        URL(string: "https://newsapi.org/v2/top-headlines?country=\(country)&apiKey=\(apikey)")!
    }
}
