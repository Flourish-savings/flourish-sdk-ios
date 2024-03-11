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
        return WKWebView()
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: "\(flourishSdkManager.endpoint.frontend)&token=\(flourishSdkManager.tokenManager.accessToken ?? "")") {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
