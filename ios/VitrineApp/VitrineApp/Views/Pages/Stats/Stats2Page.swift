import SwiftUI
import DesignSystem

// MARK: - Stats2Page

/// Figma: [Stats] 2 (node 623:33489)
///
/// Transaction History page with three stat chart cards:
/// Savings (light), Investments (medium), Expenses (dark).
struct Stats2Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: theme.spacing.sm) {
            DSTopAppBar(title: "Transaction History") {
                DSButton {}.buttonStyle(.text).buttonSize(.medium).icon(.bell)
            }.onBack { dismiss() }

            ScrollView(showsIndicators: false) {
                VStack(spacing: theme.spacing.sm) {
                    savingsCard
                    investmentsCard
                    expensesCard
                }
                .padding(.bottom, theme.spacing.sm)
            }
        }
        .padding(.horizontal, theme.spacing.sm)
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }

    // MARK: - Savings Card

    private var savingsCard: some View {
        DSCard {
            VStack(spacing: theme.spacing.lg) {
                cardHeader(
                    title: "Savings",
                    amount: "$62826",
                    titleColor: theme.colors.textNeutral9,
                    amountColor: theme.colors.textNeutral9,
                    buttonStyle: .outlined
                )

                DSStatsChart(data: monthData)
                    .linePoints(savingsLinePoints)
                    .chartStyle(.light)
                    .badgeText("$620")
                    .badgePosition(x: 0.58, y: 0.72)
            }
        }
    }

    // MARK: - Investments Card

    private var investmentsCard: some View {
        DSCard {
            VStack(spacing: theme.spacing.lg) {
                cardHeader(
                    title: "Investments",
                    amount: "$88826",
                    titleColor: theme.colors.textNeutral05,
                    amountColor: theme.colors.textNeutral05,
                    buttonStyle: .outlinedLight
                )

                DSStatsChart(data: monthData)
                    .linePoints(investmentsLinePoints)
                    .chartStyle(.medium)
                    .badgeText("$800")
                    .badgePosition(x: 0.44, y: 0.72)
            }
        }
        .cardBackground(theme.colors.surfacePrimary100)
    }

    // MARK: - Expenses Card

    private var expensesCard: some View {
        DSCard {
            VStack(spacing: theme.spacing.lg) {
                cardHeader(
                    title: "Expenses",
                    amount: "$62826",
                    titleColor: theme.colors.textNeutral05,
                    amountColor: theme.colors.textNeutral05,
                    buttonStyle: .outlinedLight
                )

                DSStatsChart(data: monthData)
                    .linePoints(expensesLinePoints)
                    .chartStyle(.dark)
                    .badgeText("$440")
                    .badgePosition(x: 0.78, y: 0.55)
            }
        }
        .cardBackground(theme.colors.surfacePrimary120)
    }

    // MARK: - Card Header

    private func cardHeader(
        title: LocalizedStringKey,
        amount: String,
        titleColor: Color,
        amountColor: Color,
        buttonStyle: DSButtonStyle
    ) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(theme.typography.h4.font)
                    .tracking(theme.typography.h4.tracking)
                    .foregroundStyle(titleColor)

                Text(amount)
                    .font(theme.typography.caption.font)
                    .tracking(theme.typography.caption.tracking)
                    .foregroundStyle(amountColor)
            }

            Spacer()

            DSButton("Year") {}.buttonStyle(buttonStyle).buttonSize(.small).icon(.arrowSeparateVertical, position: .right)
        }
    }

    // MARK: - Data

    private var monthData: [DSStatsChartData] {
        ["Jan", "Feb", "Mar", "Apr", "May", "Jun"].map {
            DSStatsChartData(label: $0, value: 1.0)
        }
    }

    // Savings: line dips in the middle (Apr area), generally flat
    private var savingsLinePoints: [DSLineChartPoint] {
        [
            DSLineChartPoint(x: 0.0, y: 0.55),
            DSLineChartPoint(x: 0.2, y: 0.65),
            DSLineChartPoint(x: 0.4, y: 0.45),
            DSLineChartPoint(x: 0.6, y: 0.35),
            DSLineChartPoint(x: 0.8, y: 0.55),
            DSLineChartPoint(x: 1.0, y: 0.50)
        ]
    }

    // Investments: rises from left, peaks around Mar-Apr
    private var investmentsLinePoints: [DSLineChartPoint] {
        [
            DSLineChartPoint(x: 0.0, y: 0.30),
            DSLineChartPoint(x: 0.2, y: 0.55),
            DSLineChartPoint(x: 0.4, y: 0.40),
            DSLineChartPoint(x: 0.6, y: 0.65),
            DSLineChartPoint(x: 0.8, y: 0.60),
            DSLineChartPoint(x: 1.0, y: 0.45)
        ]
    }

    // Expenses: wavy, peaks around Apr-May
    private var expensesLinePoints: [DSLineChartPoint] {
        [
            DSLineChartPoint(x: 0.0, y: 0.50),
            DSLineChartPoint(x: 0.2, y: 0.60),
            DSLineChartPoint(x: 0.4, y: 0.45),
            DSLineChartPoint(x: 0.6, y: 0.55),
            DSLineChartPoint(x: 0.8, y: 0.70),
            DSLineChartPoint(x: 1.0, y: 0.40)
        ]
    }
}

#Preview {
    Stats2Page()
        .previewThemed()
}
