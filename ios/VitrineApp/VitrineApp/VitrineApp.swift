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
        }
    }
}
