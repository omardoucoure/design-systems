import SwiftUI
import DesignSystem

// MARK: - Stats16Page

/// Figma: [Stats] 16 (node 626:36510)
///
/// Transactions dashboard with chart card, segmented time picker,
/// transaction list, and a bottom app bar.
struct Stats16Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPeriod = 1 // "Month" selected by default
    @State private var showChart = true

    var body: some View {
        VStack(spacing: 0) {
            // Top App Bar
            DSTopAppBar(title: "Transactions", style: .small, onBack: { dismiss() }) {
                DSButton(style: .text, size: .medium, icon: .bellOff) {}
            }

            // Scrollable content
            ScrollView {
                VStack(spacing: theme.spacing.sm) {
                    chartCard
                    periodPicker
                    transactionList
                }
                .padding(.horizontal, theme.spacing.sm)
            }
            .scrollIndicators(.hidden)
        }
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }

    // MARK: - Chart Card

    private var chartCard: some View {
        DSCard(
            background: theme.colors.surfaceSecondary100,
            radius: theme.radius.xl,
            padding: 0
        ) {
            VStack(spacing: theme.spacing.lg) {
                // Heading row
                HStack(alignment: .top) {
                    // Amount + date range
                    VStack(alignment: .leading, spacing: 2) {
                        Text("$62,826")
                            .font(theme.typography.h3.font)
                            .tracking(theme.typography.h3.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)

                        Text("26th May - 26th June")
                            .font(theme.typography.caption.font)
                            .tracking(theme.typography.caption.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)
                    }

                    Spacer()

                    // Chart / Table toggle
                    HStack(spacing: theme.spacing.sm) {
                        DSButton("Chart", style: showChart ? .neutral : .text, size: .small) {
                            withAnimation { showChart = true }
                        }
                        DSButton("Table", style: showChart ? .text : .neutral, size: .small) {
                            withAnimation { showChart = false }
                        }
                    }
                    .padding(.vertical, 2)
                }

                if showChart {
                    // Stats chart — auto-line from data values
                    DSStatsChart(
                        data: chartData,
                        style: .brand,
                        badgeText: "$620",
                        badgeX: 0.75,
                        badgeY: 0.42
                    )
                } else {
                    // Table view
                    tableView
                }
            }
            .padding(theme.spacing.xl)
        }
    }

    // MARK: - Period Picker

    private var periodPicker: some View {
        DSSegmentedPicker(
            items: ["All", "Month", "Week", "Day"],
            selectedIndex: $selectedPeriod,
            style: .pills
        )
    }

    // MARK: - Table View

    private var tableView: some View {
        VStack(spacing: 0) {
            ForEach(chartTableData) { row in
                HStack {
                    Text(row.label)
                        .font(theme.typography.caption.font)
                        .tracking(theme.typography.caption.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)

                    Spacer()

                    Text(row.value)
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }
                .padding(.vertical, theme.spacing.xs)

                if row.label != chartTableData.last?.label {
                    DSDivider(style: .fullBleed, color: theme.colors.textNeutral9.opacity(0.1))
                }
            }
        }
    }

    // MARK: - Transaction List

    private var transactionList: some View {
        DSCard(
            background: theme.colors.surfaceNeutral2,
            radius: theme.radius.xl,
            padding: 0
        ) {
            VStack(spacing: 0) {
                ForEach(Array(transactions.enumerated()), id: \.element.id) { index, transaction in
                    DSListItem(
                        headline: transaction.name,
                        supportingText: transaction.date,
                        metadata: transaction.type,
                        showDivider: index < transactions.count - 1
                    ) {
                        DSAvatar(
                            style: .image(Image(transaction.avatar)),
                            size: 40
                        )
                    } trailing: {
                        DSButton(transaction.amount, style: .neutral, size: .medium) {}
                    }
                }
            }
            .padding(.vertical, theme.spacing.lg)
        }
    }

    // MARK: - Data

    private var chartData: [DSStatsChartData] {
        [
            DSStatsChartData(label: "Jan", value: 2100),
            DSStatsChartData(label: "Feb", value: 5400),
            DSStatsChartData(label: "Mar", value: 3800),
            DSStatsChartData(label: "Apr", value: 1200),
            DSStatsChartData(label: "May", value: 4600),
            DSStatsChartData(label: "Jun", value: 3500),
        ]
    }

    // Exact Figma SVG path (viewBox 0 0 285.565 62.7793) scaled to fit
    private func figmaLinePath(size: CGSize) -> Path {
        let sx = size.width / 285.565
        let sy = size.height / 62.7793
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }

        var path = Path()
        path.move(to: p(1.50, 56.28))
        path.addLine(to: p(12.88, 52.40))
        path.addCurve(to: p(38.04, 32.66), control1: p(23.26, 48.85), control2: p(32.13, 41.89))
        path.addLine(to: p(48.82, 15.84))
        path.addCurve(to: p(61.93, 4.39), control1: p(52.01, 10.86), control2: p(56.56, 6.88))
        path.addCurve(to: p(88.48, 4.55), control1: p(70.36, 0.48), control2: p(80.09, 0.54))
        path.addLine(to: p(88.92, 4.76))
        path.addCurve(to: p(100.88, 14.62), control1: p(93.65, 7.02), control2: p(97.76, 10.41))
        path.addLine(to: p(120.47, 41.04))
        path.addCurve(to: p(130.74, 51.25), control1: p(123.37, 44.94), control2: p(126.83, 48.38))
        path.addLine(to: p(132.13, 52.27))
        path.addCurve(to: p(159.65, 61.28), control1: p(140.11, 58.12), control2: p(149.75, 61.28))
        path.addLine(to: p(161.04, 61.28))
        path.addCurve(to: p(180.13, 56.55), control1: p(167.69, 61.28), control2: p(174.25, 59.66))
        path.addCurve(to: p(195.96, 41.67), control1: p(186.65, 53.11), control2: p(192.12, 47.97))
        path.addLine(to: p(200.01, 35.03))
        path.addCurve(to: p(210.13, 25.22), control1: p(202.49, 30.95), control2: p(205.98, 27.58))
        path.addCurve(to: p(233.61, 23.26), control1: p(217.29, 21.16), control2: p(225.87, 20.45))
        path.addLine(to: p(242.84, 26.63))
        path.addCurve(to: p(255.17, 29.37), control1: p(246.81, 28.08), control2: p(250.96, 29.00))
        path.addLine(to: p(284.07, 31.93))
        return path
    }

    // Exact Figma shadow SVG path (viewBox 0 0 297.262 56.0958) scaled to fit
    private func figmaShadowPath(size: CGSize) -> Path {
        let sx = size.width / 297.262
        let sy = size.height / 56.0958
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }

        var path = Path()
        path.move(to: p(7.50, 45.19))
        path.addLine(to: p(20.60, 42.13))
        path.addCurve(to: p(44.96, 28.08), control1: p(29.93, 39.95), control2: p(38.41, 35.07))
        path.addLine(to: p(52.78, 19.74))
        path.addCurve(to: p(69.35, 9.31), control1: p(57.32, 14.90), control2: p(63.03, 11.31))
        path.addCurve(to: p(93.10, 9.42), control1: p(77.08, 6.86), control2: p(85.39, 6.90))
        path.addLine(to: p(93.70, 9.61))
        path.addCurve(to: p(108.64, 18.37), control1: p(99.25, 11.43), control2: p(104.35, 14.41))
        path.addLine(to: p(125.81, 34.17))
        path.addCurve(to: p(136.94, 41.85), control1: p(129.15, 37.24), control2: p(132.89, 39.82))
        path.addLine(to: p(140.16, 43.46))
        path.addCurve(to: p(161.88, 48.60), control1: p(146.90, 46.84), control2: p(154.34, 48.60))
        path.addLine(to: p(168.96, 48.60))
        path.addCurve(to: p(184.90, 45.81), control1: p(174.39, 48.60), control2: p(179.78, 47.65))
        path.addLine(to: p(186.17, 45.35))
        path.addCurve(to: p(203.12, 33.91), control1: p(192.69, 43.00), control2: p(198.51, 39.07))
        path.addLine(to: p(203.61, 33.36))
        path.addCurve(to: p(218.46, 23.08), control1: p(207.68, 28.80), control2: p(212.77, 25.28))
        path.addCurve(to: p(236.96, 20.75), control1: p(224.34, 20.80), control2: p(230.69, 20.00))
        path.addLine(to: p(254.29, 22.83))
        path.addLine(to: p(270.27, 22.83))
        path.addCurve(to: p(278.87, 22.06), control1: p(273.15, 22.83), control2: p(276.03, 22.57))
        path.addLine(to: p(289.76, 20.10))
        return path
    }

    private struct ChartTableRow: Identifiable {
        let id = UUID()
        let label: String
        let value: String
    }

    private var chartTableData: [ChartTableRow] {
        [
            ChartTableRow(label: "January", value: "$8,420"),
            ChartTableRow(label: "February", value: "$9,150"),
            ChartTableRow(label: "March", value: "$10,830"),
            ChartTableRow(label: "April", value: "$11,200"),
            ChartTableRow(label: "May", value: "$12,106"),
            ChartTableRow(label: "June", value: "$11,120"),
        ]
    }

    private struct Transaction: Identifiable {
        let id = UUID()
        let name: LocalizedStringKey
        let date: LocalizedStringKey
        let type: LocalizedStringKey
        let amount: LocalizedStringKey
        let avatar: String
    }

    private var transactions: [Transaction] {
        [
            Transaction(name: "Wade Warren", date: "March 23, 2033", type: "Payment", amount: "+ $88", avatar: "stats16_avatar1"),
            Transaction(name: "Jenny Wilson", date: "March 21, 2033", type: "Debit", amount: "+ $26", avatar: "stats16_avatar2"),
            Transaction(name: "Jacob Jones", date: "March 21, 2033", type: "Debit", amount: "+ $44", avatar: "stats16_avatar3"),
            Transaction(name: "Dianne Russell", date: "March 20, 2033", type: "Payment", amount: "+ $18", avatar: "stats16_avatar4"),
        ]
    }

}

#Preview {
    Stats16Page()
        .previewThemed()
}
