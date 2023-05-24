//
//  MainViewModel.swift
//  Wordpress
//
//  Created by Asil Arslan on 6.05.2021.
//

import Foundation
import SwiftyJSON
import Envato

class MainViewModel: ObservableObject {
    
    @Published var headlinePosts = [Post]()
    @Published var posts = [Post]()
    @Published var categories = [Category]()
    @Published var tags = [Tag]()
    @Published var pages = [Page]()
    @Published var selectedCategory : Category = Category.home
    @Published var page = 1
    @Published var isLoading = true
    @Published var isCategoryLoading = false
    @Published var isHeadlineLoading = false
    @Published var isFailed = false
    @Published var isRefresh = false
    
    
    func fetchHeadlineData() {
        isHeadlineLoading = true
        guard let url = URL(string: URL_HEADLINE_POSTS) else {
            print("Invalid URL")
            return
        }

        EnvatoServiceAPI.shared.fetchResources(url: url, completion: { (result: Result<[Post], EnvatoServiceAPI.APIServiceError>) in
            switch result {
                case .success(let postResponse):
                    DispatchQueue.main.async {
                        self.isHeadlineLoading = false
                        self.headlinePosts = postResponse
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        })
    }
    
    func fetchPosts() {
        isLoading = true
        guard let url = URL(string: "\(URL_POSTS)&page=\(page)") else {
            print("Invalid URL")
            return
        }

        EnvatoServiceAPI.shared.fetchResources(url: url, completion: { (result: Result<[Post], EnvatoServiceAPI.APIServiceError>) in
            switch result {
                case .success(let postResponse):
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.posts.append(contentsOf: postResponse)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.isFailed = true
                    }
            }
        })
    }
    
    func fetchCategoryPosts(category: Category) {
        isLoading = true
        guard let url = URL(string: "\(URL_CATEGORY_POST)\(category.id)&page=\(page)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.posts.append(contentsOf: decodedResponse)
                        //                            self.isLoading = false
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            DispatchQueue.main.async {
                self.isLoading = false
                self.isFailed = true
            }
            
        }.resume()
    }
    
    func fetchCategories() {
        isCategoryLoading = true
        guard let url = URL(string: URL_CATEGORIES) else {
            print("Invalid URL")
            return
        }

        EnvatoServiceAPI.shared.fetchResources(url: url, completion: { (result: Result<[Category], EnvatoServiceAPI.APIServiceError>) in
            switch result {
                case .success(let postResponse):
                    DispatchQueue.main.async {
                        self.isCategoryLoading = false
                        self.categories = postResponse
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    
            }
        })
        
    }
    
    func fetchTags() {
        guard let url = URL(string: URL_TAGS) else {
            print("Invalid URL")
            return
        }
        
        EnvatoServiceAPI.shared.fetchResources(url: url, completion: { (result: Result<[Tag], EnvatoServiceAPI.APIServiceError>) in
            switch result {
                case .success(let postResponse):
                    DispatchQueue.main.async {
                        self.tags = postResponse
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    
            }
        })
    }
    
    func fetchPages() {
        guard let url = URL(string: URL_PAGES) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Page].self, from: data) {
                    DispatchQueue.main.async {
                        self.pages = decodedResponse
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
    }
    
    func refreshPosts() {
        isLoading = true
        isRefresh = true
        posts.removeAll()
        page = 1
        if selectedCategory.id == Category.home.id {
            fetchPosts()
        }else{
            fetchCategoryPosts(category: selectedCategory)
        }
    }
}
