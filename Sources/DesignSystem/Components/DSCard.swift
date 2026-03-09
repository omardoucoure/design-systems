import SwiftUI

// MARK: - DSCard

/// A themed container card with configurable background, radius, and padding.
///
/// Used as a building block for page layouts — the "grey container" and
/// "primary container" patterns seen across page designs.
///
/// Usage:
/// ```swift
/// DSCard(background: theme.colors.surfaceNeutral2) {
///     Text("Hello")
/// }
///
/// DSCard(
///     background: theme.colors.surfacePrimary100,
///     radius: theme.radius.xl,
///     padding: theme.spacing.xl
/// ) {
///     HStack { Text("Skip") }
/// }
/// ```
public struct DSCard<Content: View>: View {
    @Environment(\.theme) private var theme

    private let background: Color?
    private let radiusOverride: CGFloat?
    private let paddingOverride: CGFloat?
    private let clipsContent: Bool
    private let content: Content

    public init(
        background: Color? = nil,
        radius: CGFloat? = nil,
        padding: CGFloat? = nil,
        clipsContent: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.background = background
        self.radiusOverride = radius
        self.paddingOverride = padding
        self.clipsContent = clipsContent
        self.content = content()
    }

    public var body: some View {
        let shaped = content
            .padding(resolvedPadding)
            .background(
                RoundedRectangle(cornerRadius: resolvedRadius)
                    .fill(resolvedBackground)
            )
        if clipsContent {
            shaped.clipShape(RoundedRectangle(cornerRadius: resolvedRadius))
        } else {
            shaped
        }
    }

    private var resolvedBackground: Color {
        background ?? theme.colors.surfaceNeutral2
    }

    private var resolvedRadius: CGFloat {
        radiusOverride ?? theme.radius.xl
    }

    private var resolvedPadding: CGFloat {
        paddingOverride ?? theme.spacing.xl
    }
}
