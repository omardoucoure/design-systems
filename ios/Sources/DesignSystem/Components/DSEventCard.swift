import SwiftUI

// MARK: - DSEventCard

/// A compact event card with title, subtitle, and trailing icon.
///
/// Figma: p=lg(24), radius lg, HStack gap=md(16).
/// Title: bodySemiBold (16px), Subtitle: tiny (10px) at 75% opacity.
///
/// Usage (modifier API):
/// ```swift
/// DSEventCard(title: "Design Systems", subtitle: "Unleash your ideas!")
///     .eventIcon(.eye)
///     .eventBackground(theme.colors.surfaceSecondary100)
///     .eventForeground(theme.colors.textNeutral9)
/// ```
public struct DSEventCard: View {
    @Environment(\.theme) private var theme

    // Core (required)
    private var _title: LocalizedStringKey
    private var _subtitle: LocalizedStringKey

    // Modifier props (optional, with defaults)
    private var _icon: DSIcon = .calendar
    private var _background: Color? = nil
    private var _foreground: Color? = nil

    // MARK: - New Modifier API

    /// Creates an event card with a title and subtitle.
    public init(title: LocalizedStringKey, subtitle: LocalizedStringKey) {
        self._title = title
        self._subtitle = subtitle
    }

    /// Sets the trailing icon. Default is `.calendar`.
    public func eventIcon(_ icon: DSIcon) -> Self {
        var copy = self; copy._icon = icon; return copy
    }

    /// Sets the card background color. Default is `surfaceSecondary100`.
    public func eventBackground(_ color: Color) -> Self {
        var copy = self; copy._background = color; return copy
    }

    /// Sets the text and icon foreground color. Default is `textNeutral9`.
    public func eventForeground(_ color: Color) -> Self {
        var copy = self; copy._foreground = color; return copy
    }

    // MARK: - Deprecated Init

    @available(*, deprecated, message: "Use DSEventCard(title:subtitle:) with modifier methods instead")
    public init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        icon: DSIcon,
        background: Color,
        foreground: Color
    ) {
        self._title = title
        self._subtitle = subtitle
        self._icon = icon
        self._background = background
        self._foreground = foreground
    }

    public var body: some View {
        let resolvedBg = _background ?? theme.colors.surfaceSecondary100
        let resolvedFg = _foreground ?? theme.colors.textNeutral9

        HStack(alignment: .top, spacing: theme.spacing.md) {
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text(_title)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(resolvedFg)
                    .lineLimit(1)

                Text(_subtitle)
                    .font(theme.typography.tiny.font)
                    .tracking(theme.typography.tiny.tracking)
                    .foregroundStyle(resolvedFg.opacity(0.75))
            }
            Spacer(minLength: 0)
            Image(dsIcon: _icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(resolvedFg)
        }
        .padding(theme.spacing.lg)
        .background(resolvedBg)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
    }
}
