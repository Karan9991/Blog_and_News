//
//  RefreshScrollView.swift
//  Wordpress
//
//  Created by Asil Arslan on 19.08.2021.
//

import UIKit
import SwiftUI

struct RefreshScrollView: UIViewRepresentable {
    
    var width: CGFloat
    var height: CGFloat
    
    @EnvironmentObject var mainViewModel: MainViewModel
    
    func makeUIView(context: Context) -> UIView {
        let scrollView = UIScrollView()
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl(sender:)), for: .allEvents)
        
        let refreshVC = UIHostingController(rootView: HomeContentView().environmentObject(mainViewModel))
        refreshVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        scrollView.addSubview(refreshVC.view)
        return scrollView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, mainViewModel: mainViewModel)
    }
    
    class Coordinator: NSObject {
        var refreshScrollView: RefreshScrollView
        var mainViewModel: MainViewModel
        
        init(_ refreshScrollView: RefreshScrollView, mainViewModel: MainViewModel) {
            self.refreshScrollView = refreshScrollView
            self.mainViewModel = mainViewModel
        }
        
        @objc func handleRefreshControl(sender: UIRefreshControl) { //handle what to do when pull is released
            sender.endRefreshing()
            print("refreshing...")
            mainViewModel.refreshPosts()
        }
        
    }
    
   
}


