import SwiftUI
import DesignSystem

// MARK: - Alert10Page

/// Figma: [Alerts] 10 (node 1025:91082)
///
/// Red error card with server icon, title, divider, message,
/// and a dark CTA card with two buttons + close button.
struct Alert10Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: theme.spacing.sm) {
            // Error card
            DSCard(
                background: theme.colors.error,
                radius: theme.radius.xl,
                padding: 0
            ) {
                DSAlert(
                    title: "Oops! Our servers are taking a nap.",
                    message: "We'll be up and buzzing again shortly!",
                    severity: .error
                ) {
                    DSIconImage(.server, size: 40, color: theme.colors.textNeutral9)
                } actions: {
                    EmptyView()
                }
                .padding(.horizontal, theme.spacing.xl)
                .padding(.vertical, theme.spacing.xxl)
            }

            // CTA card
            DSCard(
                background: theme.colors.surfacePrimary120,
                radius: theme.radius.xl,
                padding: theme.spacing.xl
            ) {
                VStack(spacing: theme.spacing.lg) {
                    DSButton(
                        "Visit Website",
                        style: .filledB,
                        size: .big,
                        icon: .www,
                        iconPosition: .right,
                        isFullWidth: true
                    ) {}

                    DSButton(
                        "Check Connection",
                        style: .outlinedLight,
                        size: .big,
                        icon: .refreshDouble,
                        iconPosition: .right,
                        isFullWidth: true
                    ) {}
                }
            }

            // Close button
            DSButton(style: .filledC, size: .big, icon: .xmark) {
                dismiss()
            }
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.bottom, theme.spacing.sm)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }
}

#Preview {
    Alert10Page()
        .previewThemed()
}
