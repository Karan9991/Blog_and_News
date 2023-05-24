//
//  WebView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    @Binding var dynamicHeight: CGFloat
    @Environment(\.colorScheme) var colorScheme
    var webview: WKWebView = WKWebView()
    var htmlContent: String = ""
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                DispatchQueue.main.async {
                    self.parent.dynamicHeight = height as! CGFloat
                }
            })
            
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
            
            switch navigationAction.navigationType {
            case .linkActivated:
                UIApplication.shared.open(navigationAction.request.url!)
                decisionHandler(.cancel)
                return
            default:
                break
            }
            decisionHandler(.allow)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
        webview.scrollView.isScrollEnabled = false
        let htmlStart = "<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></head><body>"
        let htmStyle = "<style> body {background-color: transparent; color: \(interface());  } p {background-color: transparent;} img { width:100%; height:auto; object-fit:cover; } </style>"
        let htmlEnd = "</body></html>"
        let htmlString = "\(htmlStart)\(htmStyle)\(htmlContent)\(htmlEnd)"
        webview.loadHTMLString(htmlString, baseURL:  nil)
        webview.backgroundColor = .clear
        webview.isOpaque = false
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    func interface() -> String{
        switch colorScheme {
        case .dark:
            return "white"
        case .light:
            return "black"
        default:
            return "white"
        }
        
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(dynamicHeight: .constant(CGFloat(0)))
    }
}
