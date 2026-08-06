import SwiftUI
import WebKit

struct ContentView: View {
    @EnvironmentObject private var purchases: PurchaseManager
    @State private var showingPaywall = false

    var body: some View {
        ZStack(alignment: .bottom) {
            StudyWebView(isPremium: purchases.hasPremium) {
                showingPaywall = true
            }
            .ignoresSafeArea()

            if !purchases.hasPremium {
                Button("プレミアム機能を見る") {
                    showingPaywall = true
                }
                .font(.footnote.bold())
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.orange, in: Capsule())
                .foregroundStyle(.white)
                .padding(.bottom, 12)
            }
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
                .environmentObject(purchases)
        }
    }
}

private struct StudyWebView: UIViewRepresentable {
    let isPremium: Bool
    let onShowPaywall: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onShowPaywall: onShowPaywall)
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.userContentController.add(context.coordinator, name: "purchaseBridge")
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        guard let url = Bundle.main.url(forResource: "index", withExtension: "html") else {
            return webView
        }
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let value = isPremium ? "true" : "false"
        webView.evaluateJavaScript("window.__nativePremium = \(value);")
    }

    final class Coordinator: NSObject, WKScriptMessageHandler {
        let onShowPaywall: () -> Void

        init(onShowPaywall: @escaping () -> Void) {
            self.onShowPaywall = onShowPaywall
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "purchaseBridge" else { return }
            onShowPaywall()
        }
    }
}
