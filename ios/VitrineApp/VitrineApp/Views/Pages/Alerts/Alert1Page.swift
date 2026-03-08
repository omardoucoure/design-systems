import SwiftUI
import DesignSystem

// MARK: - Alert1Page

/// Figma: [Alerts] 1 (node 1025:88409)
///
/// Offline error alert with search bar (error state),
/// overlapping dark + red cards, and "Reconnect Now" button.
struct Alert1Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    private let cardOverlap: CGFloat = 84

    var body: some View {
        // Page — Figma: gap-sm(12), pt-0, pb-sm(12), px-sm(12)
        VStack(spacing: theme.spacing.sm) {
            // Top bar — Figma: pl-sm(12), pr-xs(8), py-sm(12), gap-md(16)
            HStack(spacing: theme.spacing.md) {
                // Back button — neutral capsule, arrow-left-long asset icon
                DSButton(style: .neutral, size: .medium, icon: .arrowLeftLong) {
                    dismiss()
                }

                // Search-Add group — Figma: gap-xs(8)
                HStack(spacing: theme.spacing.xs) {
                    DSTextField(
                        text: $searchText,
                        placeholder: "Search...",
                        label: "Label",
                        variant: .filled,
                        state: .error,
                        iconLeft: "magnifyingglass"
                    )

                    // Trailing bell-notification icon (no bg, 40h container)
                    DSButton(style: .text, size: .medium, icon: .bellNotification) {}
                }
            }
            .padding(.leading, theme.spacing.sm)
            .padding(.trailing, theme.spacing.xs)
            .padding(.vertical, theme.spacing.sm)

            // Content — overlapping cards
            ScrollView {
                VStack(spacing: 0) {
                    // Alert card — surfacePrimary100, radius xl, padding xl
                    DSCard(
                        background: theme.colors.surfacePrimary100,
                        radius: theme.radius.xl,
                        padding: 0
                    ) {
                        VStack(alignment: .leading, spacing: theme.spacing.xl) {
                            // Header: wifi-xmark 40x40 + close button (surfaceNeutral0_5 bg)
                            HStack {
                                DSIconImage(.wifiXmark, size: 40, color: theme.colors.textNeutral0_5)

                                Spacer()

                                // X button — Figma: surfaceNeutral0_5 bg, capsule, 40h
                                DSButton(style: .neutralLight, size: .medium, icon: .xmark) {}
                            }

                            DSText("Stranded offline!",
                                   style: theme.typography.display2, color: theme.colors.textNeutral0_5)

                            DSDivider(style: .fullBleed, color: theme.colors.borderNeutral0_5)

                            DSText("Looks like your device decided to go rogue and ditch the internet. Let's get you back to civilization.",
                                   style: theme.typography.bodyRegular, color: theme.colors.textNeutral0_5)
                        }
                        .padding(theme.spacing.xl)
                    }
                    .zIndex(2)

                    // CTA card — surfaceSecondary100, overlapping by 84px
                    DSCard(
                        background: theme.colors.surfaceSecondary100,
                        radius: theme.radius.xl,
                        padding: 0
                    ) {
                        DSButton(
                            "Reconnect Now",
                            style: .outlined,
                            size: .big,
                            icon: .refreshDouble,
                            iconPosition: .right,
                            isFullWidth: true
                        ) {}
                        .padding(.top, cardOverlap + theme.spacing.xxl)
                        .padding(.bottom, theme.spacing.xxl)
                        .padding(.horizontal, theme.spacing.xl)
                    }
                    .padding(.top, -cardOverlap)
                    .zIndex(1)
                }
                .padding(.horizontal, theme.spacing.sm)
                .padding(.bottom, theme.spacing.sm)
            }
        }
        .background(theme.colors.surfaceNeutral0_5)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Alert1Page()
        .previewThemed()
}
