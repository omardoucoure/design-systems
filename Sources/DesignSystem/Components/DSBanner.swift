import SwiftUI

// MARK: - DSBanner

/// A floating banner/toast notification with severity-colored background.
///
/// Position (top/bottom) is controlled by the parent's ZStack layout.
///
/// Usage (modifier-based):
/// ```swift
/// DSBanner(severity: .info) {
///     // optional leading content (icon chip, badge, etc.)
/// }
/// .title("Keep going!")
/// .message("Just so you know: You're doing great!")
/// .onDismiss { showBanner = false }
/// ```
public struct DSBanner<LeadingContent: View>: View {
    @Environment(\.theme) private var theme

    // Core params (init)
    private let _severity: DSAlertSeverity
    private let _leadingContent: LeadingContent

    // Modifier params
    private var _title: LocalizedStringKey?
    private var _message: LocalizedStringKey?
    private var _onDismiss: (() -> Void)?

    /// Creates a banner with core parameters. Use modifiers for optional configuration.
    public init(
        severity: DSAlertSeverity,
        @ViewBuilder leading: () -> LeadingContent = { EmptyView() }
    ) {
        self._severity = severity
        self._leadingContent = leading()
    }

    // MARK: - Deprecated Init

    /// Deprecated: Use the modifier-based API instead.
    @available(*, deprecated, message: "Use init(severity:leading:) with .title(), .message(), .onDismiss() modifiers")
    public init(
        title: LocalizedStringKey? = nil,
        message: LocalizedStringKey? = nil,
        severity: DSAlertSeverity,
        @ViewBuilder leading: () -> LeadingContent = { EmptyView() },
        onDismiss: (() -> Void)? = nil
    ) {
        self._severity = severity
        self._leadingContent = leading()
        self._title = title
        self._message = message
        self._onDismiss = onDismiss
    }

    // MARK: - Modifiers

    /// Sets the banner title text.
    public func title(_ title: LocalizedStringKey) -> Self {
        var copy = self
        copy._title = title
        return copy
    }

    /// Sets the banner message text displayed below the title.
    public func message(_ message: LocalizedStringKey) -> Self {
        var copy = self
        copy._message = message
        return copy
    }

    /// Sets the dismiss action. When provided, a close button appears on the trailing side.
    public func onDismiss(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy._onDismiss = action
        return copy
    }

    // MARK: - Body

    public var body: some View {
        HStack(alignment: .top, spacing: theme.spacing.md) {
            // Leading content (icon chip, etc.) if provided
            if LeadingContent.self != EmptyView.self {
                _leadingContent
            }

            // Text content
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                if let _title {
                    Text(_title)
                        .font(theme.typography.h5.font)
                        .tracking(theme.typography.h5.tracking)
                        .lineSpacing(theme.typography.h5.lineSpacing)
                        .foregroundStyle(theme.colors.textNeutral9)
                }

                if let _message {
                    Text(_message)
                        .font(theme.typography.caption.font)
                        .tracking(theme.typography.caption.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Dismiss button
            if let _onDismiss {
                Button(action: _onDismiss) {
                    Image(dsIcon: .xmark)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(theme.colors.textNeutral9)
                }
                .buttonStyle(.plain)
                .padding(.vertical, theme.spacing.xxs)
            }
        }
        .padding(theme.spacing.xl)
        .background(_severity.color(from: theme.colors))
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
        .shadow(color: .black.opacity(0.02), radius: 8, x: 0, y: 4)
        .shadow(color: .black.opacity(0.18), radius: 48, x: 0, y: 24)
    }
}
