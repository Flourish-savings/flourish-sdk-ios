import SwiftUI
import WebKit

@available(iOS 12.0, *)
@available(macOS 12.0, *)
public struct FlourishSdkView: UIViewRepresentable {
    public let flourishSdkManager: FlourishSdkManager
    
    public init(flourishSdkManager: FlourishSdkManager) {
        self.flourishSdkManager = flourishSdkManager
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        let contentController = webView.configuration.userContentController
        contentController.add(context.coordinator, name: "IosWebView")
        
        webView.navigationDelegate = context.coordinator

        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: "\(flourishSdkManager.endpoint.frontend)&token=\(TokenManager.shared.authToken ?? "")") {
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

            public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
                if let messageBody = message.body as? String {
                    print("Received message from web: \(messageBody)")
                    parent.flourishSdkManager.flourishEventManager?.generateEvent(eventString: messageBody)
                }
            }
            
            public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                print("Web view finished loading.")
            }
        }
}
