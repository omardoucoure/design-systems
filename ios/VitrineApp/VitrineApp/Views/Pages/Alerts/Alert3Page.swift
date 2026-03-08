import SwiftUI
import DesignSystem

/// Figma: [Alerts] 3 - Error (node 1020:75948)
struct Alert3Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDay = "26"
    @State private var selectedTab = ""
    @State private var showError = false

    private let dayPickerItems: [DSDayPickerItem] = [
        .init(id: "22", label: "22"), .init(id: "23", label: "23"),
        .init(id: "24", label: "24"), .init(id: "25", label: "25"),
        .init(id: "26", label: "Today, 26 Mar"),
        .init(id: "27", label: "27"), .init(id: "28", label: "28"), .init(id: "29", label: "29"),
    ]

    private let bottomBarItems = [
        DSBottomBarItem(id: "home", label: "Home", icon: .home),
        DSBottomBarItem(id: "search", label: "Search", icon: .search),
        DSBottomBarItem(id: "heart", label: "Wishlist", icon: .heart),
        DSBottomBarItem(id: "user", label: "Profile", icon: .user),
    ]

    private let statItems = [
        DSStatItem(id: "distance", label: "Distance"),
        DSStatItem(id: "calories", label: "Calories"),
        DSStatItem(id: "points", label: "Points"),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: theme.spacing.sm) {
                DSTopAppBar(title: "Your Activities", style: .smallCentered, onBack: { dismiss() }) {
                    DSAvatar(style: .image(Image("avatar_contact")),
                             size: CGSize(width: 56, height: 40), shape: .roundedRect(theme.radius.sm))
                }
                DSDayPicker(items: dayPickerItems, selectedId: $selectedDay)
                ScrollView {
                    stepsGraphCard.padding(.bottom, showError ? 280 : 100)
                }
            }
            .onTapGesture {
                guard showError else { return }
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { showError = false }
            }
            errorBottomSheet
        }
        .background(theme.colors.surfaceNeutral0_5)
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4)) { showError = true }
        }
    }

    private var stepsGraphCard: some View {
        DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: theme.spacing.xl) {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                stepsInfoSection
                DSStatRow(items: statItems, dividerColor: theme.colors.textNeutral9) { statValue(for: $0.id) }
                DSStackedBarChart(columns: chartColumns, timeLabels: ["00:00", "12:00", "23:59"])
            }
        }
        .padding(.horizontal, theme.spacing.sm)
    }

    private var stepsInfoSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            DSText("Steps", style: theme.typography.caption, color: theme.colors.textNeutral8)
            HStack(spacing: theme.spacing.lg) {
                DSText("8,628", style: theme.typography.display2, color: theme.colors.textNeutral9)
                DSBadge(variant: .tagSemantic, text: "+ 12%")
            }
            DSText("Compared to Yesterday, 25 March",
                   style: theme.typography.smallRegular, color: theme.colors.textNeutral8)
        }
    }

    @ViewBuilder
    private func statValue(for id: String) -> some View {
        let text: Text = id == "distance"
            ? Text("6,268 ").font(theme.typography.largeSemiBold.font) + Text("m").font(theme.typography.tiny.font)
            : Text(id == "calories" ? "2,260" : "1,268").font(theme.typography.largeSemiBold.font)
        text.tracking(theme.typography.largeSemiBold.tracking)
            .foregroundStyle(theme.colors.textNeutral9)
            .frame(height: 27)
    }

    private var errorBottomSheet: some View {
        VStack(spacing: 0) {
            if showError {
                errorBannerContent.transition(.move(edge: .bottom).combined(with: .opacity))
            }
            ZStack(alignment: .top) {
                if showError { theme.colors.error.frame(height: theme.radius.xl) }
                DSBottomAppBar(items: bottomBarItems, selectedId: $selectedTab, style: .full,
                               fabIcon: .cart, fabColor: theme.colors.surfaceSecondary100,
                               fabForegroundColor: theme.colors.textNeutral9, fabBadgeCount: 3, onFabTap: {})
            }
        }
    }

    private var errorBannerContent: some View {
        HStack(alignment: .top, spacing: theme.spacing.lg) {
            DSIconImage(.warningTriangle, size: 20, color: theme.colors.textNeutral9)
                .padding(.horizontal, theme.spacing.sm)
                .padding(.vertical, theme.spacing.xxs)
                .frame(height: 32)
                .background(theme.colors.surfaceNeutral2)
                .clipShape(Capsule())
            (Text("Oops! ").font(theme.typography.label.font)
                + Text("Looks like your device took a little internet vacation. Please check your connection and try again.")
                    .font(theme.typography.caption.font))
                .tracking(theme.typography.caption.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
        }
        .padding(.horizontal, theme.spacing.xl)
        .padding(.top, theme.spacing.xl)
        .padding(.bottom, theme.spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.colors.error)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: theme.radius.xl, bottomLeadingRadius: 0,
                                          bottomTrailingRadius: 0, topTrailingRadius: theme.radius.xl))
        .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: -8)
        .shadow(color: .black.opacity(0.18), radius: 32, x: 0, y: -11)
    }

    // swiftlint:disable line_length
    private var chartColumns: [DSStackedBarChartColumn] {
        typealias C = DSStackedBarChartColumn; typealias S = DSStackedBarChartSegment
        let r = theme.brand.primitives.secondary120, d = theme.colors.borderNeutral8
        return [
            C(segments: [S(height: 8, color: r), S(height: 8, color: d)]), C(segments: [S(height: 8, color: r), S(height: 8, color: d)]),
            C(segments: [S(height: 8, color: r), S(height: 8, color: d)]), C(segments: [S(height: 9, color: r), S(height: 10, color: d)]),
            C(segments: [S(height: 18, color: r), S(height: 12, color: d)]), C(segments: [S(height: 16, color: r), S(height: 29, color: d)]),
            C(segments: [S(height: 42, color: r), S(height: 12, color: d)]), C(segments: [S(height: 9, color: r), S(height: 51, color: d)]),
            C(segments: [S(height: 24, color: r), S(height: 43, color: d)]), C(segments: [S(height: 48, color: r), S(height: 21, color: d)]),
            C(segments: [S(height: 67.692, color: d)]),
            C(segments: [S(height: 30, color: d), S(height: 43, color: r), S(height: 30, color: d)]),
            C(segments: [S(height: 47, color: r), S(height: 10, color: d)]), C(segments: [S(height: 10, color: r), S(height: 49, color: d)]),
            C(segments: [S(height: 32, color: r), S(height: 64, color: d)]), C(segments: [S(height: 38, color: r), S(height: 85, color: d)]),
            C(segments: [S(height: 95, color: d), S(height: 15, color: r)]), C(segments: [S(height: 42, color: r), S(height: 12, color: d)]),
            C(segments: [S(height: 16, color: r), S(height: 29, color: d)]), C(segments: [S(height: 18, color: r), S(height: 12, color: d)]),
            C(segments: [S(height: 8, color: r), S(height: 8, color: d)]), C(segments: [S(height: 8, color: r), S(height: 8, color: d)]),
        ]
    }
    // swiftlint:enable line_length
}

#Preview {
    Alert3Page()
        .previewThemed()
}
