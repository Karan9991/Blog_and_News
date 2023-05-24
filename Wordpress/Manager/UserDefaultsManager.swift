//
//  UserDefaultsManager.swift
//  News
//
//  Created by Asil Arslan on 22.12.2020.
//

import Foundation

class UserDefaultsManager{
    static let KeyForUserDefaults = "myKey"
    
    static func save(_ new: Post) {
        var news = load()
        news.append(new)
        save(news)
    }
    
    static func remove(_ new: Post) {
        var news = load()
        if let index = news.firstIndex(where: {$0.id == new.id}){
            news.remove(at: index)
        }
        save(news)
    }
    
    static func isInclude(_ id: Int) -> Bool{
        let news = load()
        if news.firstIndex(where: {$0.id == id}) != nil{
            return true
        }
        return false
    }

    static func save(_ news: [Post]) {
        let data = news.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
    }

    static func load() -> [Post] {
        guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data] else {
            return []
        }

        return encodedData.map { try! JSONDecoder().decode(Post.self, from: $0) }
    }

}

