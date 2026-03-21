import SwiftUI
import DesignSystem

@main
struct VitrineApp: App {
    @State private var brand: Brand = .coralCamo
    @State private var style: Style = .lightRounded

    var body: some Scene {
        WindowGroup {
            ContentView(brand: $brand, style: $style)
                .designSystem(brand: brand, style: style)
                .onAppear {
                    // Set window background to match theme
                    let bgColor = UIColor(red: 0.98, green: 0.98, blue: 0.976, alpha: 1)
                    if let window = UIApplication.shared.connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first?.windows.first {
                        window.backgroundColor = bgColor
                    }

                    // Make navigation bar background match the page background
                    let navAppearance = UINavigationBarAppearance()
                    navAppearance.configureWithDefaultBackground()
                    navAppearance.backgroundColor = bgColor
                    navAppearance.shadowColor = .clear
                    UINavigationBar.appearance().standardAppearance = navAppearance
                    UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
                    UINavigationBar.appearance().compactAppearance = navAppearance

                    // Make tab bar background match
                    let tabAppearance = UITabBarAppearance()
                    tabAppearance.configureWithDefaultBackground()
                    tabAppearance.backgroundColor = bgColor
                    tabAppearance.shadowColor = .clear
                    UITabBar.appearance().standardAppearance = tabAppearance
                    UITabBar.appearance().scrollEdgeAppearance = tabAppearance
                }
        }
    }
}
