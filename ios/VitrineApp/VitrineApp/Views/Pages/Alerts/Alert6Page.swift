import SwiftUI
import DesignSystem

/// Figma: [Alerts] 6 - Info (node 1021:80327)
struct Alert6Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var isMenuOpen = false
    @State private var showBanner = false

    private let monthlyData: [DSLollipopChartItem] = [
        .init(label: "Jan", height: 25), .init(label: "Feb", height: 37),
        .init(label: "Mar", height: 80), .init(label: "Apr", height: 69),
        .init(label: "May", height: 97), .init(label: "Jun", height: 123),
        .init(label: "Jul", height: 168), .init(label: "Aug", height: 142),
        .init(label: "Sep", height: 173), .init(label: "Oct", height: 206),
        .init(label: "Nov", height: 12), .init(label: "Dec", height: 12),
    ]

    var body: some View {
        DSSideMenuLayout(isOpen: $isMenuOpen) {
            sideMenuContent
        } content: {
            mainContent
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4)) { showBanner = true }
        }
    }

    private var sideMenuContent: some View {
        DSNavigationMenu(items: [
                DSNavigationMenuItem(id: "earnings", label: "Earnings", icon: .wallet, isSelected: true),
                DSNavigationMenuItem(id: "messages", label: "Messages", icon: .replyToMessage),
                DSNavigationMenuItem(id: "bookmarks", label: "Bookmarks", icon: .bookmark),
                DSNavigationMenuItem(id: "settings", label: "Settings", icon: .settings),
                DSNavigationMenuItem(id: "notifications", label: "Notifications", icon: .bellNotification),
                DSNavigationMenuItem(id: "people", label: "People", icon: .group),
            ])
            .profile(DSNavigationMenuProfile(
                image: "nav8_profile",
                name: "Hristo Hristov",
                subtitle: "Visual Designer"
            ))
        .padding(.leading, theme.spacing.sm)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
    }

    private var mainContent: some View {
        ZStack(alignment: .top) {
            VStack(spacing: theme.spacing.sm) {
                DSTopAppBar(title: "Total Earnings") {
                    DSButton {
                        withAnimation(.easeInOut(duration: 0.3)) { isMenuOpen.toggle() }
                    }.buttonStyle(.neutral).buttonSize(.medium).icon(.menuScale)
                }.appBarStyle(.smallCentered).onBack { dismiss() }
                ScrollView {
                    VStack(spacing: 0) {
                        thisMonthCard
                        thisYearCard.padding(.top, -85)
                    }
                    .padding(.horizontal, theme.spacing.sm)
                }
                .scrollIndicators(.hidden)
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
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
    }

    private var thisMonthCard: some View {
        DSCard {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    HStack(spacing: theme.spacing.xxs) {
                        DSText("This Month", style: theme.typography.h4, color: theme.colors.textNeutral9)
                        Spacer()
                        DSBadge(.tagSemantic).text("+ 12%")
                    }
                    DSText("Compared to Last Month", style: theme.typography.smallRegular, color: theme.colors.textNeutral9)
                }
                DSLollipopChart(data: monthlyData)
                    .highlightIndex(9)
                    .highlightLabel("$8,628")
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.vertical, theme.spacing.xxl)
        }
        .cardPadding(0)
        .zIndex(2)
    }

    private var thisYearCard: some View {
        DSCard {
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                DSText("This Year", style: theme.typography.caption, color: theme.colors.textNeutral2)
                HStack(spacing: theme.spacing.lg) {
                    DSText("$288,628", style: theme.typography.display2, color: theme.colors.textNeutral05)
                    DSBadge(.tagBrand).text("+ 26%")
                }
                DSText("Compared to $20,620 last year", style: theme.typography.smallRegular, color: theme.colors.textNeutral2)
            }
            .padding(.top, 110)
            .padding(.bottom, theme.spacing.xl)
            .padding(.horizontal, theme.spacing.xl)
        }
        .cardBackground(theme.colors.surfacePrimary100)
        .cardPadding(0)
        .zIndex(1)
    }
}

#Preview {
    Alert6Page()
        .previewThemed()
}
