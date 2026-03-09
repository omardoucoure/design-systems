import SwiftUI

// MARK: - DSEventCard

/// A compact event card with title, subtitle, and trailing icon.
///
/// Figma: p=lg(24), radius lg, HStack gap=md(16).
/// Title: bodySemiBold (16px), Subtitle: tiny (10px) at 75% opacity.
///
/// Usage:
/// ```swift
/// DSEventCard(
///     title: "Design Systems",
///     subtitle: "Unleash your ideas in a storm of creativity!",
///     icon: .eye,
///     background: theme.colors.surfaceSecondary100,
///     foreground: theme.colors.textNeutral9
/// )
/// ```
public struct DSEventCard: View {
    @Environment(\.theme) private var theme

    private let title: LocalizedStringKey
    private let subtitle: LocalizedStringKey
    private let icon: DSIcon
    private let background: Color
    private let foreground: Color

    public init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        icon: DSIcon,
        background: Color,
        foreground: Color
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.background = background
        self.foreground = foreground
    }

    public var body: some View {
        HStack(alignment: .top, spacing: theme.spacing.md) {
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text(title)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(foreground)
                    .lineLimit(1)

                Text(subtitle)
                    .font(theme.typography.tiny.font)
                    .tracking(theme.typography.tiny.tracking)
                    .foregroundStyle(foreground.opacity(0.75))
            }
            Spacer(minLength: 0)
            Image(dsIcon: icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(foreground)
        }
        .padding(theme.spacing.lg)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
    }
}
