//
//  FlourishSdkView.swift
//  SdkExample
//
//  Created by Yuri Logatto Pamplona on 10/03/24.
//

import SwiftUI
import WebKit

@available(macOS 14.0, *)
public struct FlourishSdkView: UIViewRepresentable {
    public let flourishSdkManager: FlourishSdkManager
    
    public init(flourishSdkManager: FlourishSdkManager) {
        self.flourishSdkManager = flourishSdkManager
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        // Add the script message handler to the user content controller
        let contentController = webView.configuration.userContentController
        contentController.add(context.coordinator, name: "IosWebView") // Use a unique name for your handler
        
        // Assign the coordinator to handle events
        webView.navigationDelegate = context.coordinator

        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: "\(flourishSdkManager.endpoint.frontend)&token=\(flourishSdkManager.tokenManager.accessToken ?? "")") {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
            var parent: FlourishSdkView

            init(_ parent: FlourishSdkView) {
                self.parent = parent
            }

            // Implement the WKScriptMessageHandler method to receive messages
            public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
                if let messageBody = message.body as? String {
                    print("Received message from web: \(messageBody)")
                    // Handle the message as needed
                }
            }
            
            // Implement other WKNavigationDelegate methods as needed
            // For example, to handle page loading events
            public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                print("Web view finished loading.")
            }
        }
}
