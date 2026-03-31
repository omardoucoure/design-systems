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
/// Usage (modifier-based):
/// ```swift
/// DSAlert(title: "Something went wrong", severity: .error) {
///     Image("server_icon")
///         .resizable()
///         .frame(width: 40, height: 40)
/// } actions: {
///     DSButton("Try Again") {}.fullWidth()
///     DSButton("Go Back") {}.buttonStyle(.outlined).fullWidth()
/// }
/// .message("We'll be up and buzzing again shortly!")
/// .showDivider(false)
/// ```
public struct DSAlert<Icon: View, Actions: View>: View {
    @Environment(\.theme) private var theme

    // Core params (init)
    private let _title: LocalizedStringKey
    private let _severity: DSAlertSeverity
    private let _icon: Icon
    private let _actions: Actions

    // Modifier params
    private var _message: LocalizedStringKey?
    private var _showDivider: Bool = true

    /// Creates an alert with core parameters. Use modifiers for optional configuration.
    public init(
        title: LocalizedStringKey,
        severity: DSAlertSeverity,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder actions: () -> Actions
    ) {
        self._title = title
        self._severity = severity
        self._icon = icon()
        self._actions = actions()
    }

    // MARK: - Deprecated Init

    /// Deprecated: Use the modifier-based API instead.
    @available(*, deprecated, message: "Use init(title:severity:icon:actions:) with .message() and .showDivider() modifiers")
    public init(
        title: LocalizedStringKey,
        message: LocalizedStringKey? = nil,
        severity: DSAlertSeverity,
        showDivider: Bool = true,
        @ViewBuilder icon: () -> Icon,
        @ViewBuilder actions: () -> Actions
    ) {
        self._title = title
        self._severity = severity
        self._icon = icon()
        self._actions = actions()
        self._message = message
        self._showDivider = showDivider
    }

    // MARK: - Modifiers

    /// Sets the alert message text displayed below the divider.
    public func message(_ message: LocalizedStringKey) -> Self {
        var copy = self
        copy._message = message
        return copy
    }

    /// Controls whether a divider is shown between the title and message. Default is `true`.
    public func showDivider(_ show: Bool) -> Self {
        var copy = self
        copy._showDivider = show
        return copy
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xl) {
            _icon

            Text(_title)
                .font(theme.typography.display2.font)
                .tracking(theme.typography.display2.tracking)
                .lineSpacing(theme.typography.display2.lineSpacing)
                .foregroundStyle(theme.colors.textNeutral9)

            if _showDivider {
                DSDivider()
            }

            if let _message {
                Text(_message)
                    .font(theme.typography.bodyRegular.font)
                    .tracking(theme.typography.bodyRegular.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
            }

            _actions
        }
    }
}
