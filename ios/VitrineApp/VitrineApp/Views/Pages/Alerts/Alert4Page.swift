import SwiftUI
import DesignSystem

/// Figma: [Alerts] 4 - Warning (node 1020:77161)
struct Alert4Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var showBanner = false

    private let heartRatePoints: [DSLineChartPoint] = [
        .init(x: 0.0, y: 0.25), .init(x: 0.18, y: 0.65), .init(x: 0.35, y: 0.25),
        .init(x: 0.50, y: 0.45), .init(x: 0.65, y: 0.25), .init(x: 1.0, y: 0.35),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: theme.spacing.sm) {
                DSTopAppBar(title: "Today") {
                    DSAvatar(style: .image(Image("avatar_contact")),
                             size: CGSize(width: 56, height: 40), shape: .roundedRect(theme.radius.sm))
                }.appBarStyle(.smallCentered).onBack { dismiss() }
                ScrollView {
                    VStack(spacing: theme.spacing.sm) {
                        HStack(alignment: .top, spacing: theme.spacing.sm) { walkCard; waterCard }
                        row2Cards
                    }
                        .padding(.horizontal, theme.spacing.sm)
                        .padding(.bottom, showBanner ? 200 : 20)
                }
                .scrollIndicators(.hidden)
            }

            if showBanner {
                warningBanner
                    .padding(.horizontal, theme.spacing.sm)
                    .padding(.bottom, theme.spacing.sm)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4)) { showBanner = true }
        }
    }

    private var walkCard: some View {
        DSMetricCard(title: "Walk", icon: .walking) {
            ZStack {
                DSProgressCircle(progress: 0.75)
                    .circleSize(104)
                    .lineWidth(6)
                    .trackLineWidth(3)
                    .customLabel(" ")
                    .trackColor(theme.colors.textNeutral05.opacity(0.2))
                    .progressColor(theme.colors.textNeutral05)
                VStack(spacing: 0) {
                    DSText("6560", style: theme.typography.h4, color: theme.colors.textNeutral05)
                    DSText("Steps", style: theme.typography.small, color: theme.colors.textNeutral05)
                }
            }
        }
        .metricBackground(theme.colors.surfacePrimary100)
        .metricForeground(theme.colors.textNeutral05)
    }

    private var waterCard: some View {
        DSMetricCard(title: "Water", icon: .droplet) {
            VStack(spacing: 0) {
                Spacer()
                waterBars
            }
        }
        .metricValue("2.48", unit: "liters")
        .metricBackground(theme.colors.surfaceSecondary100)
        .metricForeground(theme.colors.textNeutral9)
    }

    private var waterBars: some View {
        let heights: [CGFloat] = [45, 61, 38, 16, 23, 21, 17, 31, 12, 22, 36, 46, 29]
        return HStack(alignment: .bottom, spacing: 0) {
            ForEach(Array(heights.enumerated()), id: \.offset) { index, height in
                Spacer(minLength: 0)
                RoundedRectangle(cornerRadius: theme.radius.xxs)
                    .fill(theme.colors.textNeutral9.opacity(index < 7 ? 0.3 : 1.0))
                    .frame(width: 4, height: height)
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, theme.spacing.xs)
    }

    private var row2Cards: some View {
        HStack(alignment: .top, spacing: theme.spacing.sm) {
            VStack(spacing: theme.spacing.sm) {
                DSMetricCard(title: "Calories", icon: .halfCookie)
                    .metricValue("2.248", unit: "kcal")
                    .metricBackground(theme.colors.surfaceNeutral2)
                    .metricForeground(theme.colors.textNeutral9)
                DSMetricCard(title: "Sleep", icon: .eyeClosed)
                    .metricValue("6.56", unit: "hours")
                    .metricBackground(theme.colors.surfaceNeutral2)
                    .metricForeground(theme.colors.textNeutral9)
            }
            DSMetricCard(title: "Heart", icon: .heart) {
                ZStack {
                    HStack(alignment: .bottom, spacing: 0) {
                        ForEach(0..<9, id: \.self) { _ in
                            Spacer(minLength: 0)
                            RoundedRectangle(cornerRadius: theme.radius.xxs)
                                .fill(theme.colors.surfaceNeutral05.opacity(0.8))
                                .frame(width: 4)
                            Spacer(minLength: 0)
                        }
                    }
                    DSLineChart(points: heartRatePoints)
                        .lineColor(theme.colors.textNeutral9)
                        .shadowColor(theme.brand.primitives.primary120)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
            }
            .metricValue("86", unit: "bpm")
            .metricBackground(theme.colors.surfaceNeutral3)
            .metricForeground(theme.colors.textNeutral9)
        }
    }

    private var warningBanner: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            HStack {
                DSIconImage(.messageAlert, size: 20, color: theme.colors.textNeutral9)
                    .padding(.horizontal, theme.spacing.sm)
                    .padding(.vertical, theme.spacing.xxs)
                    .frame(height: 32)
                    .background(theme.colors.surfaceNeutral2)
                    .clipShape(Capsule())
                Spacer()
                DSButton {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { showBanner = false }
                }.buttonStyle(.text).buttonSize(.medium).icon(.xmark)
                .accessibilityLabel("Close warning")
                .padding(.vertical, theme.spacing.xxs)
            }
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                DSText("Heads up!", style: theme.typography.h5, color: theme.colors.textNeutral9)
                DSText("You're about to step into uncharted territory. Proceed with caution.",
                       style: theme.typography.caption, color: theme.colors.textNeutral9)
            }
        }
        .padding(theme.spacing.xl)
        .background(theme.colors.warning)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        .shadow(color: .black.opacity(0.02), radius: 8, x: 0, y: 4)
        .shadow(color: .black.opacity(0.18), radius: 48, x: 0, y: 24)
    }
}

#Preview {
    Alert4Page()
        .previewThemed()
}
