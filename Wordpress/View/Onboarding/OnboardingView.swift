//
//  OnboardingView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI

struct OnboardingView: View {
    
    var onboards: [Onboard] = ONBOARD_DATA
    
    var body: some View {

        TabView{
            ForEach(onboards) { item in
                OnboardCardView(onboard: item)
            }// :Loop
        }// :TabView
        .tabViewStyle(PageTabViewStyle())
        .padding(.vertical, 20)

    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onboards: ONBOARD_DATA).previewDevice("iPhone 11 Pro")
    }
}

