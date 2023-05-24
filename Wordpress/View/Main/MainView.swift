//
//  MainView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI
import StoreKit

struct MainView: View {
    
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @StateObject var storeManager = StoreManager ()
    @Binding var showMenu : Bool
    
    init(showMenu : Binding<Bool>) {
        self._showMenu = showMenu
    }
    
    var body: some View {
        TabView{
            HomeView(showMenu: $showMenu)
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text(LocalizedStringKey("Home"))
                }
                .environmentObject(mainViewModel)
            
            CategoryView(showMenu: $showMenu)
                .environmentObject(mainViewModel)
                .tabItem {
                    Image(systemName: "rectangle.grid.1x2")
                    Text(LocalizedStringKey("Category"))
                }
            
            FavoriteView(showMenu: $showMenu)
                .tabItem {
                    Image(systemName: "heart")
                    Text(LocalizedStringKey("Favorite"))
                }
            
            TagView(showMenu: $showMenu)
                .environmentObject(mainViewModel)
                .tabItem {
                    Image(systemName: "tag.circle")
                    Text(LocalizedStringKey("Tag"))
                }
            
            SettingView(storeManager: storeManager, showMenu: $showMenu)
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text(LocalizedStringKey("Setting"))
                }
        }
        .onAppear(perform: {
            SKPaymentQueue.default().add(storeManager)
            storeManager.getProducts(productIDs: IN_APP_PRODUCTS)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showMenu: .constant(false))
    }
}
