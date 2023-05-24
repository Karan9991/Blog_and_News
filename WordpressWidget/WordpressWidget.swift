//
//  WordpressWidget.swift
//  WordpressWidget
//
//  Created by Asil Arslan on 28.03.2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    var networkManager = NetworkManager()
    static var new = Post.default
    
    init() {
        networkManager.fetchData { posts in
            Provider.new = posts.first ?? Post.default
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), new: Provider.new)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), new: Provider.new)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        networkManager.fetchData { posts in
            let entries = [
                SimpleEntry(date: Date(), new: posts.first ?? Post.default)
            ]
            let timeline = Timeline(entries: entries, policy: .never)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let new: Post
}

struct NewsWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading){
                URLImageView(url: URL(string: entry.new._embedded?.featuredmedia?.first?.source_url ?? EMPTY_IMAGE_URL)!)
                    .frame(width: geometry.size.width , height: geometry.size.height)
                    .aspectRatio(contentMode: .fill)
                
                Color.black.opacity(0.2)
                Text(entry.new.title.rendered.decodingHTMLEntities())
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .shadow(radius: 10)
                    .padding()
            }
        }
        
        
    }
}

@main
struct WordpressWidget: Widget {
    let kind: String = "WordpressWidget"

    
    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NewsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Wordpress Widget")
        .description("A demo showcasing news the Widget Timeline.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct WordpressWidget_Previews: PreviewProvider {
    static var networkManager = NetworkManager()
    static var new = Post.default
    static var previews: some View {
        
        NewsWidgetEntryView(entry: SimpleEntry(date: Date(), new: new))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .onAppear(){
                networkManager.fetchData { posts in
                    new = posts.first ?? Post.default
                }
            }
    }
}


class NetworkManager {
    func fetchData(completion: @escaping ([Post]) -> Void) {
        guard let url = URL(string: "\(URL_POSTS)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {data, response, error in
            
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        completion(decodedResponse)
                        //                        isLoading = false
                        //                        self.posts.append(contentsOf: decodedResponse)
                        //                            self.isLoading = false
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
            //            let result = try JSONDecoder().decode(New.self, from: data)
            //            completion(result.data)
            
        }
        .resume()
    }
}
