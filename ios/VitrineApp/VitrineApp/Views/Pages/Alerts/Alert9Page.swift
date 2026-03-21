import SwiftUI
import DesignSystem

// MARK: - Alert9Page

/// Figma: [Alerts] 9 (node 1025:89208)
///
/// Neutral card with bell icon, CTA row with "GO!" button,
/// "Remind Me Later" text link, and close button.
struct Alert9Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: theme.spacing.sm) {
            // Main info card
            DSCard(
                background: theme.colors.surfaceNeutral2,
                radius: theme.radius.xl,
                padding: 0
            ) {
                DSAlert(
                    title: "Don't miss a beat! Stay in the loop!",
                    message: "Enable notifications to catch all the important updates as they happen.",
                    severity: .neutral
                ) {
                    DSIconImage(.bellNotification, size: 40, color: theme.colors.textNeutral9)
                } actions: {
                    EmptyView()
                }
                .padding(.horizontal, theme.spacing.xl)
                .padding(.vertical, theme.spacing.xxl)
            }

            // CTA card with "Turn on notifications now!" + GO! button
            DSCard(
                background: theme.colors.surfacePrimary100,
                radius: theme.radius.xl,
                padding: theme.spacing.xl
            ) {
                HStack(spacing: theme.spacing.lg) {
                    DSText("Turn on notifications now!",
                           style: theme.typography.bodyRegular, color: theme.colors.textNeutral0_5)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    DSButton("GO!", style: .filledA, size: .big) {}
                }
            }

            // Remind Me Later
            DSButton("Remind Me Later", style: .text, size: .medium) {}

            // Close button
            DSButton(style: .filledC, size: .big, icon: .xmark) {
                dismiss()
            }
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.bottom, theme.spacing.sm)
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }
}

#Preview {
    Alert9Page()
        .previewThemed()
}
