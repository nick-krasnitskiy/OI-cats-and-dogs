//
//  NewsManager.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 20.08.2021.
//

import UIKit
import CoreData

protocol NewsManagerDelegate: AnyObject {
    func didUpdateNews(_ newsManager: NewsManager, news: [Article])
    func didFailWithError(error: Error)
    func startActivityIndicator()
    func stopActivityIndicator()
}

private let apiNewsKey = "97ac8d9db2c64e82995a456fca6f29f6"
private let dataModel = CoreDataModel()
private var articles = [Article]()

enum NewsEndpoint {
    case searchEndPoint(keyWord: String)
    case topNewsEndPoint(category: String)
    
    var url: URL {
        switch self {
        case .searchEndPoint(let keyWord):
            return .makeEndpointForSearch(parameter: keyWord, apikey: apiNewsKey)
        case .topNewsEndPoint(let category):
            return .makeEndpointForTopNews(category: category, apikey: apiNewsKey)
        }
    }
}

struct NewsManager {
    
    weak var delegate: NewsManagerDelegate?
    
    func fetchTopNews(category: String) {
        let endpointOne = NewsEndpoint.topNewsEndPoint(category: category).url
        performRequestForTopNews(with: endpointOne)
    }
    
    func fetchSearchNews(keyWord: String) {
        let endpointTwo = NewsEndpoint.searchEndPoint(keyWord: keyWord).url
        performRequestForTopNews(with: endpointTwo)
    }
    
    func performRequestForTopNews(with url: URL) {
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if error != nil {
                    articles = dataModel.getDataFromCD()
                    self.delegate?.didUpdateNews(self, news: articles)
                    return
                } else {
                    if let safeData = data {
                        if let news = self.parseJSONForTopNews(safeData) {
                            dataModel.deleteAllData()
                            self.delegate?.didUpdateNews(self, news: news.articles)
                            for article in news.articles {
                                let source = Source(id: article.source.id, name: article.source.name)
                                let article = Article(source: source, title: article.title, url: article.url, urlToImage: article.urlToImage, publishedAt: article.publishedAt, content: article.content)
                                dataModel.saveData(with: article)
                            }
                        }
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
            let news = News(status: decodedData.status, totalResults: decodedData.totalResults, articles: decodedData.articles)
            return news
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

private extension URL {
    static func makeEndpointForSearch(parameter: String, apikey: String) -> URL {
        guard let url  = URL(string: "https://newsapi.org/v2/everything?q=\(parameter)&apiKey=\(apikey)&sortBy=relevancy") else {
             fatalError("Endpoint was not сreated")
        }
        return url
    }
    
    static func makeEndpointForTopNews(category: String, apikey: String) -> URL {
        guard let url  = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apikey)&category=\(category)") else {
            fatalError("Endpoint was not сreated")
       }
       return url
    }
}
