import SwiftUI

// MARK: - Alert Severity

/// Severity levels for alerts, dialogs, and banners.
/// Maps to semantic colors from the theme.
public enum DSAlertSeverity: CaseIterable, Sendable {
    case error
    case warning
    case success
    case info
    case neutral
}

extension DSAlertSeverity {
    /// Resolves the accent color for this severity from the given color tokens.
    public func color(from colors: ColorTokens) -> Color {
        switch self {
        case .error: return colors.error
        case .warning: return colors.warning
        case .success: return colors.validated
        case .info: return colors.infoFocus
        case .neutral: return colors.surfaceNeutral2
        }
    }
}

// MARK: - DSAlert (Full-Page Alert)

/// A full-page alert component with icon, title, message, and action buttons.
///
/// Usage:
/// ```swift
/// DSAlert(
///     title: "Something went wrong",
///     message: "We'll be up and buzzing again shortly!",
///     severity: .error
/// ) {
///     Image("server_icon")
///         .resizable()
///         .frame(width: 40, height: 40)
/// } actions: {
///     DSButton("Try Again", style: .filledB, size: .big, isFullWidth: true) {}
///     DSButton("Go Back", style: .outlined, size: .big, isFullWidth: true) {}
/// }
/// ```
public struct DSAlert<Icon: View, Actions: View>: View {
    @Environment(\.theme) private var theme

    private let title: LocalizedStringKey
    private let message: LocalizedStringKey?
    private let severity: DSAlertSeverity
    private let showDivider: Bool
    private let icon: Icon
    private let actions: Actions

    public init(
        title: LocalizedStringKey,
        message: LocalizedStringKey? = nil,
        severity: DSAlertSeverity,
        showDivider: Bool = true,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder actions: () -> Actions
    ) {
        self.title = title
        self.message = message
        self.severity = severity
        self.showDivider = showDivider
        self.icon = icon()
        self.actions = actions()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xl) {
            icon

            Text(title)
                .font(theme.typography.display2.font)
                .tracking(theme.typography.display2.tracking)
                .lineSpacing(theme.typography.display2.lineSpacing)
                .foregroundStyle(theme.colors.textNeutral9)

            if showDivider {
                DSDivider(style: .fullBleed)
            }

            if let message {
                Text(message)
                    .font(theme.typography.bodyRegular.font)
                    .tracking(theme.typography.bodyRegular.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
            }

            actions
        }
    }
}
