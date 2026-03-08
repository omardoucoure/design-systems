import SwiftUI
import DesignSystem

/// Figma: [Alerts] 6 - Info (node 1021:80327)
struct Alert6Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var showBanner = false
    @State private var selectedTab = ""

    private let bottomBarItems = [
        DSBottomBarItem(id: "home", label: "Home", icon: .home),
        DSBottomBarItem(id: "wallet", label: "Wallet", icon: .wallet),
        DSBottomBarItem(id: "stats", label: "Stats", icon: .statsUpSquare),
        DSBottomBarItem(id: "grid", label: "Grid", icon: .viewGrid),
    ]

    private let monthlyData: [DSLollipopChartItem] = [
        .init(label: "Jan", height: 25), .init(label: "Feb", height: 37),
        .init(label: "Mar", height: 80), .init(label: "Apr", height: 69),
        .init(label: "May", height: 97), .init(label: "Jun", height: 123),
        .init(label: "Jul", height: 168), .init(label: "Aug", height: 142),
        .init(label: "Sep", height: 173), .init(label: "Oct", height: 206),
        .init(label: "Nov", height: 12), .init(label: "Dec", height: 12),
    ]

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: theme.spacing.sm) {
                DSTopAppBar(title: "Total Earnings", style: .smallCentered, onBack: { dismiss() }) {
                    DSButton(style: .neutral, size: .medium, icon: .menuScale) {}
                }
                ScrollView {
                    VStack(spacing: 0) {
                        thisMonthCard
                        thisYearCard.padding(.top, -85)
                    }
                    .padding(.horizontal, theme.spacing.sm)
                    .padding(.bottom, 100)
                }
                .scrollIndicators(.hidden)
            }
            VStack {
                Spacer()
                DSBottomAppBar(items: bottomBarItems, selectedId: $selectedTab,
                               style: .floating, fabIcon: .arrowUp, onFabTap: {})
            }
            if showBanner {
                DSBanner(title: "Keep going!", message: "Just so you know: You're doing great!",
                         severity: .info, onDismiss: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { showBanner = false }
                })
                .padding(.horizontal, theme.spacing.sm)
                .padding(.top, 132)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(theme.colors.surfaceNeutral0_5)
        .navigationBarBackButtonHidden(true).dsTabBarHidden()
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4)) { showBanner = true }
        }
    }

    private var thisMonthCard: some View {
        DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: 0) {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    HStack(spacing: theme.spacing.xxs) {
                        DSText("This Month", style: theme.typography.h4, color: theme.colors.textNeutral9)
                        Spacer()
                        DSBadge(variant: .tagSemantic, text: "+ 12%")
                    }
                    DSText("Compared to Last Month", style: theme.typography.smallRegular, color: theme.colors.textNeutral9)
                }
                DSLollipopChart(data: monthlyData, highlightIndex: 9, highlightLabel: "$8,628")
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.vertical, theme.spacing.xxl)
        }
        .zIndex(2)
    }

    private var thisYearCard: some View {
        DSCard(background: theme.colors.surfacePrimary100, radius: theme.radius.xl, padding: 0) {
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                DSText("This Year", style: theme.typography.caption, color: theme.colors.textNeutral2)
                HStack(spacing: theme.spacing.lg) {
                    DSText("$288,628", style: theme.typography.display2, color: theme.colors.textNeutral0_5)
                    DSBadge(variant: .tagBrand, text: "+ 26%")
                }
                DSText("Compared to $20,620 last year", style: theme.typography.smallRegular, color: theme.colors.textNeutral2)
            }
            .padding(.top, 110)
            .padding(.bottom, theme.spacing.xl)
            .padding(.horizontal, theme.spacing.xl)
        }
        .zIndex(1)
    }
}

#Preview {
    Alert6Page()
        .previewThemed()
}
