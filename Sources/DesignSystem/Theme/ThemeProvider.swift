import SwiftUI

// MARK: - Environment Key (iOS 16 compatible)

private struct ThemeKey: EnvironmentKey {
    static let defaultValue = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)
}

extension EnvironmentValues {
    /// The current design system theme configuration.
    public var theme: ThemeConfiguration {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// MARK: - Theme Provider View Modifier

private struct DesignSystemModifier: ViewModifier {
    let brand: Brand
    let style: Style

    init(brand: Brand, style: Style) {
        FontRegistration.registerFonts()
        self.brand = brand
        self.style = style
    }

    func body(content: Content) -> some View {
        content
            .environment(\.theme, ThemeConfiguration(brand: brand, style: style))
    }
}

extension View {
    /// Applies the HaHo Design System theme to this view hierarchy.
    ///
    /// Usage:
    /// ```swift
    /// ContentView()
    ///     .designSystem(brand: .coralCamo, style: .lightRounded)
    /// ```
    public func designSystem(brand: Brand, style: Style) -> some View {
        modifier(DesignSystemModifier(brand: brand, style: style))
    }
}

// MARK: - Theme Provider Container

/// A container view that provides the design system theme and registers fonts.
public struct ThemeProvider<Content: View>: View {
    private let brand: Brand
    private let style: Style
    private let content: Content

    public init(brand: Brand, style: Style, @ViewBuilder content: () -> Content) {
        FontRegistration.registerFonts()
        self.brand = brand
        self.style = style
        self.content = content()
    }

    public var body: some View {
        content
            .designSystem(brand: brand, style: style)
    }
}
