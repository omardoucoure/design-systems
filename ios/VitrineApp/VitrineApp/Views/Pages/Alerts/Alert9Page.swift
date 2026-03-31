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
            DSCard {
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
            .cardPadding(0)

            // CTA card with "Turn on notifications now!" + GO! button
            DSCard {
                HStack(spacing: theme.spacing.lg) {
                    DSText("Turn on notifications now!",
                           style: theme.typography.bodyRegular, color: theme.colors.textNeutral05)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    DSButton("GO!") { }.buttonStyle(.filledA)
                }
            }
            .cardBackground(theme.colors.surfacePrimary100)

            // Remind Me Later
            DSButton("Remind Me Later") { }.buttonStyle(.text).buttonSize(.medium)

            // Close button
            DSButton { dismiss() }.buttonStyle(.filledC).icon(.xmark)
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.bottom, theme.spacing.sm)
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }
}

#Preview {
    Alert9Page()
        .previewThemed()
}
