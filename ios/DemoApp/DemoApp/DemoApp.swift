import SwiftUI
import DesignSystem

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView()
            }
            .designSystem(brand: .coralCamo, style: .lightRounded)
        }
    }
}
