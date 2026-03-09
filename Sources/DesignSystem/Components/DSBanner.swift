import SwiftUI

// MARK: - DSBanner

/// A floating banner/toast notification with severity-colored background.
///
/// Position (top/bottom) is controlled by the parent's ZStack layout.
///
/// Usage:
/// ```swift
/// DSBanner(
///     title: "Keep going!",
///     message: "Just so you know: You're doing great!",
///     severity: .info,
///     onDismiss: { showBanner = false }
/// )
/// ```
public struct DSBanner<LeadingContent: View>: View {
    @Environment(\.theme) private var theme

    private let title: LocalizedStringKey?
    private let message: LocalizedStringKey?
    private let severity: DSAlertSeverity
    private let leadingContent: LeadingContent
    private let onDismiss: (() -> Void)?

    /// Banner with optional custom leading content (icon chip, badge, etc.)
    public init(
        title: LocalizedStringKey? = nil,
        message: LocalizedStringKey? = nil,
        severity: DSAlertSeverity,
        @ViewBuilder leading: () -> LeadingContent = { EmptyView() },
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.severity = severity
        self.leadingContent = leading()
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(alignment: .top, spacing: theme.spacing.md) {
            // Leading content (icon chip, etc.) if provided
            if LeadingContent.self != EmptyView.self {
                leadingContent
            }

            // Text content
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                if let title {
                    Text(title)
                        .font(theme.typography.h5.font)
                        .tracking(theme.typography.h5.tracking)
                        .lineSpacing(theme.typography.h5.lineSpacing)
                        .foregroundStyle(theme.colors.textNeutral9)
                }

                if let message {
                    Text(message)
                        .font(theme.typography.caption.font)
                        .tracking(theme.typography.caption.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Dismiss button
            if let onDismiss {
                Button(action: onDismiss) {
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
        .background(severity.color(from: theme.colors))
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
        .shadow(color: .black.opacity(0.02), radius: 8, x: 0, y: 4)
        .shadow(color: .black.opacity(0.18), radius: 48, x: 0, y: 24)
    }
}
