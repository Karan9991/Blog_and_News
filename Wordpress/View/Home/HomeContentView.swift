//
//  HomeContentView.swift
//  Wordpress
//
//  Created by Asil Arslan on 19.08.2021.
//

import SwiftUI
import Kingfisher
import Envato

struct HomeContentView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @Namespace var animation
    var interstitial:Interstitial = Interstitial()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVStack(alignment: .center, spacing: 10) {
                
                
                if IS_CATEGORIES_VISIBLE {
                    Section{
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            
                            HStack(alignment: .top){
                                TabButton(category: Category.home, selectedCategory: $mainViewModel.selectedCategory, animation: animation)
                                    .onTabChanged{ (newCrop) in
                                        mainViewModel.isLoading = false
                                        mainViewModel.isFailed = false
                                        mainViewModel.posts.removeAll()
                                        mainViewModel.page = 1
                                        mainViewModel.fetchPosts()
                                    }
                                ForEach(mainViewModel.categories){tab in
                                    
                                    // Tab Button...
                                    
                                    TabButton(category: tab, selectedCategory: $mainViewModel.selectedCategory, animation: animation)
                                        .onTabChanged{ (category) in
                                            mainViewModel.isLoading = false
                                            mainViewModel.isFailed = false
                                            mainViewModel.posts.removeAll()
                                            mainViewModel.page = 1
                                            mainViewModel.fetchCategoryPosts(category:category)
                                            if !UserDefaults.standard.bool(forKey: "remove_ads") {
                                                self.interstitial.showAd()
                                            }
                                        }
                                }
                            }
                        })
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical)
                        .redacted(reason: mainViewModel.isLoading ? .placeholder : [])
                    }
                }
                
                
                if IS_HEADLINE_VISIBLE && mainViewModel.selectedCategory.id == Category.home.id{
                    Section(header: HeaderView(text: "Headline")) {
                        
                        if HEADLINE_TYPE == .single {
                            ZStack {
                                // embed as hidden in ZStack to remove right arrow
                                NavigationLink(destination: PostView(new: mainViewModel.posts.first ?? Post.default)) {
                                    //
                                }
                                .hidden()
                                NewsHeadlineView(post: mainViewModel.headlinePosts.first ?? Post.default)
                            }
                        }else{
                            GeometryReader { geometry in
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(mainViewModel.headlinePosts) { item in
                                            NavigationLink(
                                                destination: PostView(new: item),
                                                label: {
                                                    KFImage(URL(string: (item._embedded?.featuredmedia?.first?.media_details?.sizes?.medium?.source_url ?? EMPTY_IMAGE_URL)) ?? URL(string: EMPTY_IMAGE_URL)!)
                                                        
                                                        .loadImmediately()
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: geometry.size.width - 50, height: 300)
                                                        .cornerRadius(35)
                                                        .overlay(
                                                            VStack(alignment: .leading) {
                                                                Spacer()
                                                                TitleAndDateView(post: item)
                                                            }
                                                            .padding()
                                                            .background(LinearGradient(gradient: Gradient(colors: [Color("ColorHeadline"), Color.clear]), startPoint: .bottom, endPoint: .top).cornerRadius(35))
                                                        )
                                                })
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .frame(height: 310).listRowInsets(EdgeInsets())
                            .redacted(reason: mainViewModel.isLoading ? .placeholder : [])
                        }
                    }
                }
                Section(header: HeaderView(text: "Latest")) {
                    ForEach (mainViewModel.posts) { row in
                        NavigationLink(destination: PostView(new: row)) {
                            VStack {
                                PostRowView(post: row)
                                    .padding(.leading)
                                Divider()
                            }
                        }
                    }
                    if !mainViewModel.isFailed {
                        HStack {
                            Image(systemName: "arrow.down")
                            Text("Scroll to new posts").font(.footnote)
                                .onAppear {
                                    if EnvatoServiceAPI.shared.isCodeVerfied() {
                                        if mainViewModel.selectedCategory.id == Category.home.id {
                                            if !mainViewModel.isLoading && !mainViewModel.isFailed {
                                                mainViewModel.page = mainViewModel.page + 1
                                                mainViewModel.fetchPosts()
                                            }
                                        }else{
                                            if !mainViewModel.isLoading && !mainViewModel.isFailed {
                                                mainViewModel.page = mainViewModel.page + 1
                                                mainViewModel.fetchCategoryPosts(category: mainViewModel.selectedCategory)
                                            }
                                        }
                                        print("Reached end of scroll view")
                                    }
                                    
                                }
                        }
                    }else{
                        HStack {
                            Text("End of Posts").font(.footnote)
                        }
                        .padding()
                    }
                    
                }
                .redacted(reason: mainViewModel.isLoading ? .placeholder : []) 
                
            }
            
        })
    }
}

struct HomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeContentView()
    }
}
