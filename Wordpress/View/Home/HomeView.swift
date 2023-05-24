//
//  HomeView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI
import Kingfisher


struct HomeView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @Namespace var animation
    @Binding var showMenu : Bool
    @State var selectedCategory : Category = Category.home
    
    var body: some View {
        
        ZStack {
            NavigationView {
                
                //                GeometryReader { geo in
                //                    RefreshScrollView(width: geo.size.width, height: geo.size.height)
                //                        .environmentObject(mainViewModel)
                //                }
                HomeContentView()
                    .environmentObject(mainViewModel)
                    .navigationBarTitle(LocalizedStringKey("Home"))
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                withAnimation{
                                    
                                    self.showMenu.toggle()
                                }
                            }, label: {
                                
                                Image(systemName: self.showMenu ? "xmark" : "line.horizontal.3")
                                    .font(.title2)
                            })
                        }
                    })
            }
            // prevent iPad split view
            .navigationViewStyle(StackNavigationViewStyle())
            
            
            if mainViewModel.isLoading {
                //                ProgressView().progressViewStyle(CircularProgressViewStyle())
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showMenu: .constant(false))
    }
}
