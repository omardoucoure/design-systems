import SwiftUI
import DesignSystem

// MARK: - Alert2Page

/// Figma: [Alerts] 2 (node 1025:89301)
///
/// Profile page with camera access alert card,
/// top app bar (back + title + menu), and bottom app bar.
struct Alert2Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var selectedTab = "user"

    private let bottomBarItems = [
        DSBottomBarItem(id: "home", label: "Home", icon: .home),
        DSBottomBarItem(id: "graph", label: "Stats", icon: .graphUp),
        DSBottomBarItem(id: "calendar", label: "Calendar", icon: .calendar),
        DSBottomBarItem(id: "user", label: "Profile", icon: .user),
    ]

    var body: some View {
        // Page — Figma: bg surfaceNeutral0_5, gap-sm(12), px-sm(12), py-0
        ZStack(alignment: .bottom) {
            VStack(spacing: theme.spacing.sm) {
                // Top App Bar — Figma: gap-none(0), status bar + nav bar
                DSTopAppBar(title: "Profile", style: .smallCentered, onBack: { dismiss() }) {
                    DSButton(style: .neutral, size: .medium, icon: .menuScale) {}
                }

                // Alert card — Figma: surfaceNeutral2, radius xl, p=xl(32), gap=xl(32)
                ScrollView {
                    DSCard(
                        background: theme.colors.surfaceNeutral2,
                        radius: theme.radius.xl,
                        padding: theme.spacing.xl
                    ) {
                        VStack(alignment: .leading, spacing: theme.spacing.xl) {
                            // Icons row — Figma: HStack, justify-between
                            HStack {
                                DSIconImage(.mediaImagePlus, size: 40, color: theme.colors.textNeutral9)

                                Spacer()

                                // Close button — Figma: surfaceNeutral0_5 bg → .neutralLight
                                DSButton(style: .neutralLight, size: .medium, icon: .xmark) {}
                            }

                            DSText("Chase down that beloved snapshot!",
                                   style: theme.typography.display2, color: theme.colors.textNeutral9)

                            // Divider — Figma: fullBleed, default color (dark on light bg)
                            DSDivider(style: .fullBleed)

                            DSText("With just a few taps, you can snap up and upload your star-studded profile pic.",
                                   style: theme.typography.bodyRegular, color: theme.colors.textNeutral9)

                            // CTA bar — Figma: surfacePrimary120, radius xl, p=xl(32), h=104, gap=lg(24)
                            DSCard(
                                background: theme.colors.surfacePrimary120,
                                radius: theme.radius.xl,
                                padding: theme.spacing.xl
                            ) {
                                HStack(spacing: theme.spacing.lg) {
                                    DSText("Let's Access Your Camera?",
                                           style: theme.typography.label, color: theme.colors.textNeutral0_5)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    // Go button — Figma: surfacePrimary100 → .filledB, medium, camera icon right
                                    DSButton(
                                        "Go!",
                                        style: .filledB,
                                        size: .medium,
                                        icon: .camera,
                                        iconPosition: .right
                                    ) {}
                                }
                            }
                        }
                    }
                    .padding(.horizontal, theme.spacing.sm)
                    // Extra bottom padding so content doesn't hide behind bottom bar
                    .padding(.bottom, 100)
                }
            }

            // Bottom App Bar — Figma: absolute bottom, .full style, FAB plus, active=user(secondary100)
            DSBottomAppBar(
                items: bottomBarItems,
                selectedId: $selectedTab,
                style: .full,
                fabIcon: .plus,
                onFabTap: {}
            )
        }
        .background(theme.colors.surfaceNeutral0_5)
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
    }
}

#Preview {
    Alert2Page()
        .previewThemed()
}
