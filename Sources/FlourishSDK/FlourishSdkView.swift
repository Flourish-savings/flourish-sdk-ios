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
        context.coordinator.authToken = TokenManager.shared.authToken ?? ""
        
        loadWebView(uiView: webView, token: context.coordinator.authToken)

        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func loadWebView(uiView: WKWebView, token: String) {
        if let url = URL(string: "\(flourishSdkManager.endpoint.frontend)&token=\(token)") {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

    public func reloadWebView(uiView: WKWebView, coordinator: Coordinator) {
        coordinator.authToken = TokenManager.shared.authToken ?? ""
        loadWebView(uiView: uiView, token: coordinator.authToken)
    }
    
    func findWebView(in view: UIView) -> WKWebView? {
        if let webView = view as? WKWebView {
            return webView
        }
        
        for subview in view.subviews {
            if let found = findWebView(in: subview) {
                return found
            }
        }
        return nil
    }
    
    public func handleInvalidToken() {
        flourishSdkManager.requestAccessToken { result in
            switch result {
            case .success(_):
                if let window = UIApplication.shared.keyWindow,
                   let root = window.rootViewController?.view {
                    if let webView = findWebView(in: root),
                       let coordinator = webView.navigationDelegate as? Coordinator {
                        self.reloadWebView(uiView: webView, coordinator: coordinator)
                    } else {
                        print("WKWebView not found in the view hierarchy")
                    }
                }
            case .failure(let error):
                print("Re-authentication failed: \(error)")
            }
        }
    }

    public class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: FlourishSdkView
        var authToken: String

        init(_ parent: FlourishSdkView) {
            self.parent = parent
            self.authToken = TokenManager.shared.authToken ?? ""
        }

        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if let messageBody = message.body as? String {
                print("Received message from web: \(messageBody)")

                if messageBody == "INVALID_TOKEN" {
                    parent.handleInvalidToken()
                } else {
                    parent.flourishSdkManager.flourishEventManager?.generateEvent(eventString: messageBody)
                }
            }
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Web view finished loading.")
        }
    }
}
