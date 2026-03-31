import SwiftUI

// MARK: - DSCard

/// A themed container card with modifier-based customization.
///
/// Usage:
/// ```swift
/// // Minimal — uses theme defaults (surfaceNeutral2, radius xl, padding xl)
/// DSCard {
///     Text("Hello")
/// }
///
/// // Full customization via modifiers
/// DSCard {
///     HStack { Text("Skip") }
/// }
/// .cardBackground(theme.colors.surfacePrimary100)
/// .cardRadius(theme.radius.xl)
/// .cardPadding(theme.spacing.xl)
///
/// // Disable content clipping (e.g., for overflow scroll)
/// DSCard {
///     content
/// }
/// .cardBackground(theme.colors.surfaceNeutral2)
/// .clipsContent(false)
/// ```
public struct DSCard<Content: View>: View {
    @Environment(\.theme) private var theme

    private let content: Content

    // Configurable via modifiers (all have defaults)
    private var _background: Color?
    private var _radius: CGFloat?
    private var _padding: CGFloat?
    private var _clipsContent: Bool = true

    // MARK: - Init (minimal)

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - Deprecated init (backward compat)

    @available(*, deprecated, message: "Use DSCard { content }.cardBackground().cardRadius().cardPadding() instead")
    public init(
        background: Color? = nil,
        radius: CGFloat? = nil,
        padding: CGFloat? = nil,
        clipsContent: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self._background = background
        self._radius = radius
        self._padding = padding
        self._clipsContent = clipsContent
        self.content = content()
    }

    // MARK: - Modifiers

    public func cardBackground(_ color: Color) -> Self {
        var copy = self
        copy._background = color
        return copy
    }

    public func cardRadius(_ radius: CGFloat) -> Self {
        var copy = self
        copy._radius = radius
        return copy
    }

    public func cardPadding(_ padding: CGFloat) -> Self {
        var copy = self
        copy._padding = padding
        return copy
    }

    public func clipsContent(_ clips: Bool = true) -> Self {
        var copy = self
        copy._clipsContent = clips
        return copy
    }

    // MARK: - Body

    public var body: some View {
        let shaped = content
            .padding(resolvedPadding)
            .background(
                RoundedRectangle(cornerRadius: resolvedRadius)
                    .fill(resolvedBackground)
            )
        if _clipsContent {
            shaped.clipShape(RoundedRectangle(cornerRadius: resolvedRadius))
        } else {
            shaped
        }
    }

    private var resolvedBackground: Color {
        _background ?? theme.colors.surfaceNeutral2
    }

    private var resolvedRadius: CGFloat {
        _radius ?? theme.radius.xl
    }

    private var resolvedPadding: CGFloat {
        _padding ?? theme.spacing.xl
    }
}
