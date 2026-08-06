import SwiftUI
import WebKit

struct ContentView: View {
    var body: some View {
        StudyWebView()
            .ignoresSafeArea()
    }
}

private struct StudyWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        guard let url = Bundle.main.url(forResource: "index", withExtension: "html") else {
            return webView
        }
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}
