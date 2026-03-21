import SwiftUI
import DesignSystem

// MARK: - Stats17Page

/// Figma: [Stats] 17 (node 661:13550)
///
/// Player statistics comparison with two player cards,
/// a dual horizontal bar chart, and a floating action button.
struct Stats17Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var isMenuOpen = false

    var body: some View {
        DSSideMenuLayout(isOpen: $isMenuOpen) {
            sideMenuContent
        } content: {
            mainContent
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }

    private var sideMenuContent: some View {
        DSNavigationMenu(
            items: [
                DSNavigationMenuItem(id: "statistics", label: "Statistics", icon: .activity, isSelected: true),
                DSNavigationMenuItem(id: "messages", label: "Messages", icon: .replyToMessage),
                DSNavigationMenuItem(id: "bookmarks", label: "Bookmarks", icon: .bookmark),
                DSNavigationMenuItem(id: "settings", label: "Settings", icon: .settings),
                DSNavigationMenuItem(id: "notifications", label: "Notifications", icon: .bellNotification),
                DSNavigationMenuItem(id: "people", label: "People", icon: .group),
            ],
            profile: DSNavigationMenuProfile(
                image: "stats17_player1",
                name: "Hristo Hristov",
                subtitle: "Sports Fan"
            )
        )
        .padding(.leading, theme.spacing.sm)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
    }

    private var mainContent: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: theme.spacing.sm) {
                topAppBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: theme.spacing.sm) {
                        playerCards
                        chartCard
                    }
                    .padding(.bottom, 80)
                }
            }
            .padding(.horizontal, theme.spacing.sm)

            fabButton
        }
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
    }

    // MARK: - Top App Bar

    private var topAppBar: some View {
        DSTopAppBar(title: "Statistics", style: .smallCentered, onBack: { dismiss() }) {
            DSButton(style: .neutral, size: .medium, icon: .menuScale) {
                withAnimation(.easeInOut(duration: 0.3)) { isMenuOpen.toggle() }
            }
        }
    }

    // MARK: - Player Cards

    private var playerCards: some View {
        HStack(spacing: theme.spacing.sm) {
            playerCard(
                image: "stats17_player1",
                name: "Courtney H.",
                location: "Chicago, IL",
                score: "286,864",
                icon: .arrowUpRight
            )

            playerCard(
                image: "stats17_player2",
                name: "Robert Fox",
                location: "San Francisco, CA",
                score: "267,586",
                icon: .arrowDownRight
            )
        }
    }

    private func playerCard(
        image: String,
        name: String,
        location: String,
        score: LocalizedStringKey,
        icon: DSIcon
    ) -> some View {
        DSCard(
            background: theme.colors.surfaceNeutral2,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                // Avatar + more icon
                HStack(alignment: .top) {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 56, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm))

                    Spacer()

                    DSButton(style: .text, size: .small, icon: .moreVert) {}
                }

                // Name + location
                VStack(alignment: .leading, spacing: 0) {
                    Text(name)
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)

                    Text(location)
                        .font(theme.typography.small.font)
                        .tracking(theme.typography.small.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                        .opacity(0.5)
                }

                // Score button
                DSButton(score, style: .neutralLight, size: .small, icon: icon, iconPosition: .right) {}
                    .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Chart Card

    private var chartCard: some View {
        DSCard(
            background: theme.colors.surfaceNeutral2,
            radius: theme.radius.xl,
            padding: 0
        ) {
            DSHorizontalBarChart(
                data: chartData,
                leftColor: theme.brand.primitives.secondary120,
                rightColor: theme.colors.borderNeutral9_5,
                rightOpacity: 0.75
            )
            .padding(.horizontal, theme.spacing.xl)
            .padding(.vertical, theme.spacing.xxxl)
        }
    }

    // MARK: - FAB Button

    private var fabButton: some View {
        DSButton("Choose Players", style: .filledA, size: .big, icon: .playstationGamepad, iconPosition: .right) {}
            .shadow(color: .black.opacity(0.02), radius: 8, x: 0, y: 4)
            .shadow(color: .black.opacity(0.18), radius: 48, x: 0, y: 24)
            .padding(.bottom, theme.spacing.sm)
    }

    // MARK: - Data

    /// Bar widths from Figma (normalized to max width ~120px)
    private var chartData: [DSHorizontalBarChartData] {
        [
            DSHorizontalBarChartData(label: "90", leftValue: 0.41, rightValue: 0.94),
            DSHorizontalBarChartData(label: "80", leftValue: 0.95, rightValue: 0.73),
            DSHorizontalBarChartData(label: "70", leftValue: 0.55, rightValue: 0.80),
            DSHorizontalBarChartData(label: "60", leftValue: 0.21, rightValue: 0.18),
            DSHorizontalBarChartData(label: "50", leftValue: 0.86, rightValue: 0.73),
            DSHorizontalBarChartData(label: "40", leftValue: 1.00, rightValue: 0.09),
            DSHorizontalBarChartData(label: "30", leftValue: 0.86, rightValue: 1.00),
            DSHorizontalBarChartData(label: "20", leftValue: 0.21, rightValue: 0.52),
            DSHorizontalBarChartData(label: "10", leftValue: 0.73, rightValue: 0.37),
            DSHorizontalBarChartData(label: "0", leftValue: 0.41, rightValue: 0.43)
        ]
    }
}

#Preview {
    Stats17Page()
        .previewThemed()
}
