import SwiftUI
import DesignSystem

// MARK: - Profile5Page

/// Figma: [Profile] 7 (node 320:7324)
///
/// Profile with avatar, bio, stats, two dark stat cards with
/// progress circles, and a views bar chart card.
struct Profile5Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: theme.spacing.sm) {
            DSTopAppBar(title: "Profile", style: .smallCentered, onBack: { dismiss() }) {
                DSButton(style: .neutral, size: .medium, icon: .menuScale) {}
            }

            ScrollView {
                VStack(spacing: theme.spacing.sm) {
                    profileInfoCard
                    statsCard
                    viewsCard
                }
                .padding(.horizontal, theme.spacing.sm)
                .padding(.bottom, theme.spacing.sm)
            }
        }
        .background(theme.colors.surfaceNeutral0_5)
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
    }

    // MARK: - Profile Info

    private var profileInfoCard: some View {
        DSCard(
            background: theme.colors.surfaceNeutral2,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Avatar + name + bio
                HStack(alignment: .top, spacing: theme.spacing.lg) {
                    Image("profile5_avatar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 61, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: theme.spacing.md))

                    VStack(alignment: .leading, spacing: theme.spacing.sm) {
                        DSText("Hristo Hristov",
                               style: theme.typography.h4, color: theme.colors.textNeutral9)

                        (Text("Sports superhero. Training for the office chair Olympics... ")
                            .font(theme.typography.caption.font)
                            .foregroundColor(theme.colors.textNeutral9)
                         + Text("read more")
                            .font(theme.typography.label.font)
                            .foregroundColor(theme.colors.textNeutral9))
                    }
                }

                DSDivider(style: .fullBleed)

                // Stats row
                HStack(spacing: 0) {
                    statColumn("1,200", label: "photos")
                    statColumn("2,980", label: "followers")
                    statColumn("1,600", label: "following")

                    DSButton(style: .filledA, size: .medium, icon: .plus) {}
                }
            }
        }
    }

    // MARK: - Stats Card

    private var statsCard: some View {
        DSCard(
            background: theme.colors.surfacePrimary120,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            VStack(spacing: theme.spacing.xl) {
                statRow(
                    title: "560 works done",
                    subtitle: "268 works in progress",
                    date: "March, 2030",
                    value: "560",
                    progress: 0.65,
                    barPattern: [4, 4, 20, 12, 4, 4, 4, 4],
                    highlightRange: 0..<4
                )

                statRow(
                    title: "12,380 reviews",
                    subtitle: "3h22m / 832m",
                    date: "April, 2030",
                    value: "12,380",
                    progress: 0.85,
                    barPattern: [4, 4, 4, 12, 20, 4, 4, 4],
                    highlightRange: 2..<5
                )
            }
        }
    }

    // MARK: - Views Card

    private var viewsCard: some View {
        DSCard(
            background: theme.colors.surfaceNeutral3,
            radius: theme.radius.xl,
            padding: 0
        ) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                // Header
                HStack {
                    DSText("Views of your profile",
                           style: theme.typography.caption, color: theme.colors.textNeutral9)

                    Spacer()

                    DSBadge(variant: .tagSemantic, text: "14,238")
                }

                // Bar chart — 32 bars, max height 56
                DSBarChart(
                    data: viewBars.map { DSBarChartData(label: "", value: CGFloat($0) / 56.0) },
                    barColor: theme.colors.textNeutral9.opacity(0.5),
                    highlightColor: theme.colors.textNeutral9,
                    highlightIndex: nil,
                    maxHeight: 56
                )
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.top, theme.spacing.xl)
            .padding(.bottom, theme.spacing.lg)
        }
    }

    // MARK: - Helpers

    private func statColumn(_ value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            DSText(value, style: theme.typography.largeSemiBold, color: theme.colors.textNeutral9)
            DSText(label, style: theme.typography.smallRegular, color: theme.colors.textNeutral9)
                .opacity(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func statRow(
        title: String,
        subtitle: String,
        date: String,
        value: String,
        progress: CGFloat,
        barPattern: [CGFloat],
        highlightRange: Range<Int>
    ) -> some View {
        HStack(spacing: theme.spacing.lg) {
            // Info + mini bars
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                VStack(alignment: .leading, spacing: 0) {
                    DSText(title,
                           style: theme.typography.largeSemiBold, color: theme.colors.textNeutral0_5)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    DSText(subtitle,
                           style: theme.typography.smallRegular, color: theme.colors.textNeutral0_5)
                        .lineLimit(1)
                }

                // Mini stat bars
                HStack(alignment: .bottom, spacing: theme.spacing.xs) {
                    ForEach(Array(barPattern.enumerated()), id: \.offset) { index, height in
                        RoundedRectangle(cornerRadius: 100)
                            .fill(highlightRange.contains(index)
                                  ? theme.colors.surfaceSecondary100
                                  : theme.colors.surfaceNeutral0_5)
                            .frame(width: 4, height: height)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Rotated date
            DSText(date, style: theme.typography.smallRegular, color: theme.colors.textNeutral0_5)
                .rotationEffect(.degrees(-90))
                .fixedSize()

            // Progress circle
            DSProgressCircle(
                progress: progress,
                size: 88,
                customLabel: value,
                progressColor: theme.colors.surfaceNeutral0_5,
                labelColor: theme.colors.textNeutral0_5
            )
        }
    }

    private let viewBars: [Int] = [
        35, 56, 38, 49, 28, 26, 35, 48, 56, 35, 48, 52,
        35, 26, 35, 18, 30, 12, 18, 16, 13, 10,
        17, 24, 9, 17, 4, 28, 56, 36, 51, 23
    ]
}

#Preview {
    Profile5Page()
        .previewThemed()
}
