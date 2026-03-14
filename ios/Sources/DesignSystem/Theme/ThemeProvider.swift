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
    let primaryColor: Color?
    let secondaryColor: Color?

    init(brand: Brand, style: Style, primaryColor: Color? = nil, secondaryColor: Color? = nil) {
        FontRegistration.registerFonts()
        self.brand = brand
        self.style = style
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }

    func body(content: Content) -> some View {
        content
            .environment(\.theme, ThemeConfiguration(
                brand: brand,
                style: style,
                primaryColor: primaryColor,
                secondaryColor: secondaryColor
            ))
    }
}

extension View {
    /// Applies the HaHo Design System theme to this view hierarchy.
    ///
    /// Usage:
    /// ```swift
    /// // Use a predefined brand
    /// ContentView()
    ///     .designSystem(brand: .coralCamo, style: .lightRounded)
    ///
    /// // Override with custom brand colors
    /// ContentView()
    ///     .designSystem(brand: .coralCamo, style: .lightRounded,
    ///                   primaryColor: Color(hex: "#1A73E8"),
    ///                   secondaryColor: Color(hex: "#EA4335"))
    /// ```
    public func designSystem(
        brand: Brand,
        style: Style,
        primaryColor: Color? = nil,
        secondaryColor: Color? = nil
    ) -> some View {
        modifier(DesignSystemModifier(brand: brand, style: style, primaryColor: primaryColor, secondaryColor: secondaryColor))
    }
}

// MARK: - Theme Provider Container

/// A container view that provides the design system theme and registers fonts.
public struct ThemeProvider<Content: View>: View {
    private let brand: Brand
    private let style: Style
    private let primaryColor: Color?
    private let secondaryColor: Color?
    private let content: Content

    public init(
        brand: Brand,
        style: Style,
        primaryColor: Color? = nil,
        secondaryColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        FontRegistration.registerFonts()
        self.brand = brand
        self.style = style
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.content = content()
    }

    public var body: some View {
        content
            .designSystem(brand: brand, style: style, primaryColor: primaryColor, secondaryColor: secondaryColor)
    }
}
