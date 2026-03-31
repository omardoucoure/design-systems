import SwiftUI
import DesignSystem

// MARK: - Stats11Page

/// Figma: [Stats] 11 (node 668:14826)
///
/// Weather dashboard with graph card, day/night temp cards,
/// and a segmented forecast picker.
struct Stats11Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var isMenuOpen = false
    @State private var selectedTab = 0

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
        DSNavigationMenu(items: [
                DSNavigationMenuItem(id: "weather", label: "Weather", icon: .sunLight, isSelected: true),
                DSNavigationMenuItem(id: "messages", label: "Messages", icon: .replyToMessage),
                DSNavigationMenuItem(id: "bookmarks", label: "Bookmarks", icon: .bookmark),
                DSNavigationMenuItem(id: "settings", label: "Settings", icon: .settings),
                DSNavigationMenuItem(id: "notifications", label: "Notifications", icon: .bellNotification),
                DSNavigationMenuItem(id: "people", label: "People", icon: .group),
            ])
            .profile(DSNavigationMenuProfile(
                image: "nav8_profile",
                name: "Hristo Hristov",
                subtitle: "Weather Watcher"
            ))
        .padding(.leading, theme.spacing.sm)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
    }

    private var mainContent: some View {
        VStack(spacing: theme.spacing.sm) {
            DSTopAppBar(title: "Today") {
                DSButton {}.buttonStyle(.neutral).buttonSize(.medium).icon(.search)
            }.appBarStyle(.smallCentered).onBack { dismiss() }
            .overlay(alignment: .leading) {
                DSButton {
                    withAnimation(.easeInOut(duration: 0.3)) { isMenuOpen.toggle() }
                }.buttonStyle(.neutral).buttonSize(.medium).icon(.menuScale)
                .padding(.leading, theme.spacing.sm)
            }

            VStack(spacing: theme.spacing.sm) {
                weatherGraphCard
                dayNightCards
            }

            Spacer(minLength: 0)

            segmentedPicker
        }
        .padding(.horizontal, theme.spacing.sm)
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
    }

    // MARK: - Weather Graph Card

    private var weatherGraphCard: some View {
        DSCard {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                // Info
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    Text("Weather")
                        .font(theme.typography.caption.font)
                        .tracking(theme.typography.caption.tracking)
                        .foregroundStyle(theme.colors.textNeutral8)

                    Text("San Francisco, CA")
                        .font(theme.typography.h3.font)
                        .tracking(theme.typography.h3.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }

                // Chart
                DSWeatherChart(data: weatherData)
                    .linePoints(temperatureLinePoints)
                    .barColor(theme.colors.borderNeutral95)
                    .barOpacity(0.6)
                    .highlightColor(theme.brand.primitives.secondary120)
                    .lineColor(theme.brand.primitives.secondary120)
                    .maxBarHeight(174)
                    .barWidth(8)
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.vertical, theme.spacing.xxl)
        }
        .cardPadding(0)
    }

    // MARK: - Day / Night Cards

    private var dayNightCards: some View {
        HStack(spacing: theme.spacing.sm) {
            // Day card
            DSCard {
                VStack(alignment: .leading, spacing: theme.spacing.xl) {
                    HStack {
                        Text("Day")
                            .font(theme.typography.largeSemiBold.font)
                            .tracking(theme.typography.largeSemiBold.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)

                        Spacer()

                        Image(dsIcon: .sunLight)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(theme.colors.textNeutral9)
                    }

                    Text("+ 78° F")
                        .font(theme.typography.h1.font)
                        .tracking(theme.typography.h1.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }
            }
            .cardBackground(theme.colors.surfaceSecondary100)

            // Night card
            DSCard {
                VStack(alignment: .leading, spacing: theme.spacing.xl) {
                    HStack {
                        Text("Night")
                            .font(theme.typography.largeSemiBold.font)
                            .tracking(theme.typography.largeSemiBold.tracking)
                            .foregroundStyle(theme.colors.textNeutral05)

                        Spacer()

                        Image(dsIcon: .halfMoon)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(theme.colors.textNeutral05)
                    }

                    Text("+ 62° F")
                        .font(theme.typography.h1.font)
                        .tracking(theme.typography.h1.tracking)
                        .foregroundStyle(theme.colors.textNeutral05)
                }
            }
            .cardBackground(theme.colors.surfacePrimary100)
        }
    }

    // MARK: - Segmented Picker

    private var segmentedPicker: some View {
        HStack(spacing: theme.spacing.xxs) {
            pickerButton(
                title: "Forecast",
                icon: .systemRestart,
                isSelected: selectedTab == 0
            ) { selectedTab = 0 }

            pickerButton(
                title: "Air quality",
                icon: .wind,
                isSelected: selectedTab == 1
            ) { selectedTab = 1 }
        }
        .padding(theme.spacing.xs)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        .padding(.horizontal, theme.spacing.xl)
        .padding(.vertical, theme.spacing.md)
    }

    private func pickerButton(
        title: String,
        icon: DSIcon,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: theme.spacing.xs) {
                Text(title)
                    .font(theme.typography.label.font)
                    .tracking(theme.typography.label.tracking)

                Image(dsIcon: icon)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .foregroundStyle(
                isSelected
                    ? theme.colors.textNeutral05
                    : theme.colors.textNeutral9
            )
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            .background(
                isSelected
                    ? theme.colors.surfacePrimary120
                    : Color.clear
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Data

    private var weatherData: [DSWeatherChartData] {
        [
            DSWeatherChartData(label: "M", value: "0", barHeight: 8),
            DSWeatherChartData(label: "T", value: "0", barHeight: 8),
            DSWeatherChartData(label: "W", value: "20", barHeight: 47),
            DSWeatherChartData(label: "T", value: "30", barHeight: 61),
            DSWeatherChartData(label: "F", value: "16", barHeight: 33),
            DSWeatherChartData(label: "S", value: "40", barHeight: 91, isHighlighted: true),
            DSWeatherChartData(label: "S", value: "36", barHeight: 61)
        ]
    }

    // Temperature line curve — matches Figma line path
    private var temperatureLinePoints: [DSLineChartPoint] {
        [
            DSLineChartPoint(x: 0.0, y: 0.30),
            DSLineChartPoint(x: 0.167, y: 0.25),
            DSLineChartPoint(x: 0.333, y: 0.55),
            DSLineChartPoint(x: 0.5, y: 0.65),
            DSLineChartPoint(x: 0.667, y: 0.45),
            DSLineChartPoint(x: 0.833, y: 0.80),
            DSLineChartPoint(x: 1.0, y: 0.70)
        ]
    }
}

#Preview {
    Stats11Page()
        .previewThemed()
}
