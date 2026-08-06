import SwiftUI

@main
struct StudySprintApp: App {
    @StateObject private var purchases = PurchaseManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(purchases)
        }
    }
}
