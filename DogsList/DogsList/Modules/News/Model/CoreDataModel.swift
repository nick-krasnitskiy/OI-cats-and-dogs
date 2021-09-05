//
//  CoreDataModel.swift
//  DogsList
//
//  Created by Nick Krasnitskiy on 04.09.2021.
//

import UIKit
import CoreData

final class CoreDataModel {
    
    private let appDelegate: AppDelegate
    private let context: NSManagedObjectContext
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func saveData(with article: Article) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "NewsModel", in: context) else { return }
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            newValue.setValue(article.source.name, forKey: "source")
            newValue.setValue(article.title, forKey: "title")
            newValue.setValue(article.url, forKey: "url")
            newValue.setValue(article.urlToImage, forKey: "imageURL")
            newValue.setValue(article.publishedAt, forKey: "date")
            newValue.setValue(article.content, forKey: "content")
            
            do {
                try context.save()
                print("Saved \(article.title)")
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getDataFromCD() -> [Article] {
        var articles = [Article]()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<NewsModel> = NewsModel.fetchRequest()
            
            if let objects = try? context.fetch(fetchRequest) {
                for newsModel in objects {
                    let source = Source(id: nil, name: newsModel.source!)
                    let article = Article(
                        source: source,
                        title: newsModel.title!,
                        url: newsModel.url!,
                        urlToImage: newsModel.imageURL,
                        publishedAt: newsModel.date!,
                        content: newsModel.content
                    )
                    articles.append(article)
                }
            }
            
        }
        return articles
    }
    
    func deleteAllData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<NewsModel> = NewsModel.fetchRequest()
            
            if let objects = try? context.fetch(fetchRequest) {
                for object in objects {
                    context.delete(object)
                }
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
